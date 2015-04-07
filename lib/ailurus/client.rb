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
  end
end
