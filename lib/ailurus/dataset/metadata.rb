require "json"

module Ailurus
  class Dataset
    # Public: Retrieve metadata about this Dataset.
    #
    # TODO: Figure out a good way to cache this so we don't keep hitting it.
    #
    # Returns a Hash.
    def metadata
      endpoint = "/api/1.0/dataset/#{@slug}/"
      begin
        @client.make_request(endpoint)
      rescue JSON::JSONError
        nil
      end
    end

    # Public: Get the indexed name for a field so you can perform more detailed
    # searches if desired.
    #
    # column_name - A String matching the name of a column in the Dataset.
    #
    # Returns a String or nil, depending on whether the field is indexed.
    def get_indexed_name(field_name)
      column_schema = self.metadata.column_schema
      indexed_names_by_column_name = Hash[column_schema.map do |schema_entry|
        [schema_entry.name, schema_entry.indexed_name]
      end]
      indexed_names_by_column_name[field_name]
    end
  end
end
