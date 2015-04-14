require "json"
require "ostruct"

require "ailurus/dataset"

module Ailurus
  # Public: Initialize a client object through which to interact with a PANDA
  # server.
  #
  # config  - A Hash of configuration options, including, at a minimum:
  #
  #           :api_key  - An API key for a user on the PANDA server.
  #           :domain   - The hostname of the PANDA server.
  #           :email    - The email address of the PANDA user.
  class Client
    attr_accessor :api_key, :domain, :email

    def initialize(config = {})
      config.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      [
        {
          :description => "API key",
          :env_var => "PANDA_API_KEY",
          :instance_var => :@api_key
        },
        {
          :description => "email address",
          :env_var => "PANDA_EMAIL",
          :instance_var => :@email
        },
        {
          :description => "PANDA server domain",
          :env_var => "PANDA_DOMAIN",
          :instance_var => :@domain
        },
      ].each do |item|
        if not self.instance_variable_defined?(item[:instance_var])
          if not ENV.has_key?(item[:env_var])
            raise ArgumentError, (
              "No #{item[:description]} specified in arguments or " +
              "#{item[:env_var]} environment variable")
          end
          self.instance_variable_set(item[:instance_var], ENV[item[:env_var]])
        end
      end
    end

    # Internal: Return the parsed JSON from a given API endpoint after adding
    # the appropriate domain and authentication parameters.
    #
    # endpoint  - The path component of the URL to the desired API endpoint
    #             (e.g., /api/1.0/dataset/).
    # params    - A Hash of GET parameters to add to the request (default:
    #             none).
    #
    # Returns the parsed JSON response, regardless of type.
    def make_request(endpoint, params = {}, method = :get)
      req_url = URI.join(Ailurus::Utils::get_absolute_uri(@domain), endpoint)
      auth_params = {
        :format => "json",
        :email => @email,
        :api_key => @api_key
      }

      res = case method
            when :get
              req_url.query = URI.encode_www_form(auth_params.merge(params))
              Net::HTTP.get_response(req_url)
            when :post
              req_url.query = URI.encode_www_form(auth_params)
              Net::HTTP.start(req_url.hostname, req_url.port) do |http|
                http.post(req_url.request_uri, JSON.generate(params))
              end
            else
              raise NotImplementedError
            end

      if res.body && res.body.length >= 2
        JSON.parse(res.body, :object_class => OpenStruct)
      else
        nil
      end
    end

    # Public: Return a Dataset instance with the given slug.
    #
    # slug  - The slug to a PANDA Dataset, as described at
    #         http://panda.readthedocs.org/en/1.1.1/api.html#datasets
    #
    # Returns an Ailurus::Dataset.
    def dataset(slug)
      Ailurus::Dataset.new(self, slug)
    end
  end
end
