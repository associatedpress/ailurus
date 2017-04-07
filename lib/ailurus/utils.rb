require "uri"

module Ailurus
  module Utils
    # Internal: Convert a domain string into a fully qualified URI.
    #
    # domain_string - A string with a hostname, optional protocol/scheme and
    #                 optional port.
    #
    # Returns a URI::HTTP instance.
    def self.get_absolute_uri(domain_string)
      begin
        uri = URI(domain_string)
        if not uri.is_a?(URI::HTTP)
          uri = URI("http://#{domain_string}")
        end
        uri
      rescue URI::InvalidURIError => e
        if /(\d{,3}\.){3}\d{,3}:\d+/.match(domain_string)
          uri = URI("http://#{domain_string}")
        else
          raise e
        end
      end
    end
  end
end
