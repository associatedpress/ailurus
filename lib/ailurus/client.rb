require "json"
require "net/http"

require "ailurus/utils"

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

    def dataset(slug)
      dataset_url = URI.join(
        Ailurus::Utils::get_absolute_uri(@domain),
        "/api/1.0/dataset/#{slug}/")  # FIXME: Prohibit `..` et al.
      dataset_url.query = URI.encode_www_form({
        :format => "json",
        :email => @email,
        :api_key => @api_key
      })

      res = Net::HTTP.get_response(dataset_url)
      return JSON.parse(res.body)  # TODO: Do more with this.
    end
  end
end
