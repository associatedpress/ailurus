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
    # offset  - The number of rows to exclude from the beginning of the results
    #           before returning what follows; for example, to get the last
    #           third of a 30-row set, you would need an offset of 20.
    # limit   - The maximum number of rows to return, after honoring the
    #           offset; for example, to get the last third of a 30-row set, you
    #           would need a limit of 10.
    #
    # Returns an Array of Arrays.
    def data_rows(offset = 0, limit = 100)
      endpoint = "/api/1.0/dataset/#{slug}/data/"
      params = {
        "offset" => offset,
        "limit" => limit
      }

      res = @client.make_request(endpoint, params)
      if res.objects.empty? && res.meta.next.nil?
        raise RangeError, "No data available for offset #{offset}"
      end

      res.objects.map { |row| row.data }
    end

    # Internal: Retrieve a set of rows from the Dataset, specified by page
    # number and page length.
    #
    # page_num      - The 0-indexed page number of data to retrieve.
    # rows_per_page - The number of rows to include on each page.
    #
    # Returns an Array of Arrays.
    def data_page(page_num = 0, rows_per_page = 100)
      self.data_rows(offset = page_num * rows_per_page, limit = rows_per_page)
    end

    def data(rows_per_page = 100)
      rows = []
      page_num = 0
      while true
        begin
          rows.concat(self.data_page(
            page_num = page_num, rows_per_page = rows_per_page))
        rescue RangeError
          break
        end
        page_num += 1
      end
      rows
    end
  end
end
