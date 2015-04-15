module Ailurus
  class Dataset
    # Public: Create this Dataset on the server.
    #
    # This instance's @slug will be used as its `name`, too, as that's defined
    # in the API.
    #
    # columns - An Array of Hashes, one per column, about columns expected to
    #           be in the Dataset. Each Hash SHOULD contain at least a :name,
    #           but it also MAY contain a :type (e.g., "int", "unicode",
    #           "bool"--default is "unicode") and/or :index (true or false,
    #           depending on whether you want the column to be indexed--default
    #           is false) (default: none).
    #
    # additional_params - A Hash of other properties to set on the Dataset,
    #                     such as description and title (default: none).
    #
    # Returns a metadata object, such as the one returned by Dataset#metadata.
    def create(columns = [], additional_params = {})
      # Start with the bare minimum.
      payload = {
        "name" => @slug,
        "slug" => @slug
      }

      # Add the columns. This requires the addition of up to three separate
      # parameters, each comma-delimited and in a consistent order.
      column_info = {}
      if not columns.empty?
        column_info["columns"] = columns.each_with_index.map do |column, index|
          column.fetch(:name, "column_#{index}")
        end.join(",")
        column_info["column_types"] = columns.map do |column|
          column.fetch(:type, "unicode")
        end.join(",")
        column_info["typed_columns"] = columns.map do |column|
          # FIXME: Probably should check whether non-false values _actually_
          # are true.
          column.fetch(:index, false).to_s
        end.join(",")
      end

      # Add other properties as specified.
      payload.merge!(additional_params)

      # Let's do this thing!
      @client.make_request(
        "/api/1.0/dataset/", :method => :post,
        :query => column_info, :body => payload)
    end
  end
end
