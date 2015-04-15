require "ailurus/dataset/create"
require "ailurus/dataset/metadata"
require "ailurus/dataset/search"
require "ailurus/dataset/update"

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
  end
end
