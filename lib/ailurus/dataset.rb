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
      @client.make_request(endpoint)
    end

    # Internal: Retrieve a set of rows from the Dataset, specified by offset
    # and length.
    #
    # query   - A query string to use when searching the data.
    # offset  - The number of rows to exclude from the beginning of the results
    #           before returning what follows; for example, to get the last
    #           third of a 30-row set, you would need an offset of 20.
    # limit   - The maximum number of rows to return, after honoring the
    #           offset; for example, to get the last third of a 30-row set, you
    #           would need a limit of 10.
    #
    # Returns an Array of Arrays.
    def data_rows(query = nil, offset = 0, limit = 100, additional_params = {})
      endpoint = "/api/1.0/dataset/#{slug}/data/"
      params = {
        "offset" => offset,
        "limit" => limit
      }
      if query.nil?
        raise NotImplementedError, (
          "API returns unexpected results without a query present, so query is
          required for now.")
      else
        params["q"] = query
      end

      params.merge!(additional_params)

      res = @client.make_request(endpoint, :query => params)
      if res.objects.empty? && res.meta.next.nil?
        raise RangeError, "No data available for offset #{offset}"
      end

      res.objects.map { |row| row.data }
    end

    # Internal: Retrieve a set of rows from the Dataset, specified by page
    # number and page length.
    #
    # query         - A query string to use when searching the data.
    # page_num      - The 0-indexed page number of data to retrieve.
    # rows_per_page - The number of rows to include on each page.
    #
    # Returns an Array of Arrays.
    def data_page(
        query = nil, page_num = 0, rows_per_page = 100, additional_params = {})
      self.data_rows(
        query = query,
        offset = page_num * rows_per_page,
        limit = rows_per_page,
        additional_params = additional_params)
    end

    # Public: Search the Dataset with a given query.
    #
    # Queries currently are required due to some observed problems with the
    # PANDA API. See Dataset#data_rows.
    #
    # query - A query string to use when searching the data.
    #
    # Returns an Array of Arrays.
    def search(query = nil, additional_params = {})
      rows = []
      page_num = 0
      while true
        begin
          rows.concat(self.data_page(
            query = query,
            page_num = page_num,
            rows_per_page = 100,
            additional_params = additional_params))
        rescue RangeError
          break
        end
        page_num += 1
      end
      rows
    end

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
        "name": @slug,
        "slug": @slug
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
