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
    def make_request(endpoint, params = {})
      # FIXME: Prohibit `..` et al. in endpoints.
      req_url = URI.join(Ailurus::Utils::get_absolute_uri(@domain), endpoint)
      req_url.query = URI.encode_www_form({
        :format => "json",
        :email => @email,
        :api_key => @api_key
      }.merge(params))

      res = Net::HTTP.get_response(req_url)
      return JSON.parse(res.body)
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
