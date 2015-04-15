module Ailurus
  class Dataset
    # Public: Retrieve metadata about this Dataset.
    #
    # Returns a Hash.
    def metadata
      endpoint = "/api/1.0/dataset/#{@slug}/"
      @client.make_request(endpoint)
    end
  end
end
