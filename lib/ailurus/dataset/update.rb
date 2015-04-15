module Ailurus
  class Dataset
    # Public: Update the data in this Dataset.
    #
    # rows  - An Array of data Hashes containing the following properties:
    #         "objects"     - An Array of Strings in the same order as this
    #                         Dataset's columns. If you don't know what order
    #                         your columns are in, call Dataset#metadata and
    #                         check the result's `column_schema` attribute.
    #         "external_id" - An optional String identifying this row of data.
    #                         Providing an external ID will allow future calls
    #                         to Dataset#update to update this row with new
    #                         information (assuming the same ID is used for one
    #                         of its rows) rather than create a new row
    #                         altogether. See http://bit.ly/1zeeax1 for more
    #                         information.
    #
    # Returns an OpenStruct describing the rows that were created and/or
    # updated.
    def update(rows = [])
      @client.make_request(
        "/api/1.0/dataset/#{@slug}/data/",
        :method => :put,
        :body => {
          "objects" => rows
        })
    end
  end
end
