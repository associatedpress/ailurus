require "json"
require "net/http"

require "ailurus/utils"

module Ailurus
  # Public: A class corresponding to a PANDA Dataset.
  #
  # client  - An Ailurus::Client instance (see `/lib/ailurus/client.rb`).
  # slug    - The slug to a PANDA Dataset, as described at
  #           http://panda.readthedocs.org/en/1.1.1/api.html#datasets
  class Dataset
    attr_accessor :client, :slug

    def initialize(client, slug)
      @client = client
      @slug = slug
    end

    # Public: Retrieve metadata about this Dataset.
    #
    # Returns a Hash.
    def metadata
      endpoint = "/api/1.0/dataset/#{@slug}/"
      @client.make_request(endpoint)  # TODO: Do more with this.
    end
  end
end
