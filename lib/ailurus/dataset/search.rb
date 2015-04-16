module Ailurus
  class Dataset
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
    def search(query = nil, options = {})
      # Handle optional arguments.
      max_results = options.fetch(:max_results, nil)
      additional_params = options.fetch(:options, {})

      rows = []
      page_num = 0

      while true  # Warning: Infinite loop! Remember to break.
        # Get the current page of results. If there aren't any results on that
        # page, we're done.
        begin
          rows.concat(self.data_page(
            query = query,
            page_num = page_num,
            rows_per_page = 100,
            additional_params = additional_params))
        rescue RangeError
          break  # Escape the infinite loop!
        end

        # If we have at least as many results as we're supposed to return,
        # we're done! (Truncating as necessary, of course.)
        if !max_results.nil? && rows.length >= max_results
          rows.slice!(max_results, rows.length - max_results)
          break  # Escape the infinite loop!
        end

        # Move on to the next page.
        page_num += 1
      end

      rows
    end
  end
end
