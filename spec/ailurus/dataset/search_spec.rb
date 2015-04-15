require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  context "searches" do
    context "hits the correct endpoints" do
      before(:each) do
        stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
        stub_request(
          :any, /panda\.example\.com\/api\/1\.0\/dataset\/example\/data\//
        ).to_return(:body => '{"objects": [], "meta": {"next": "yes please"}}')

        @dataset = make_test_client.dataset("example")
      end

      it "handles row offset/limit" do
        @dataset.data_rows(query = "hello", offset = 20, limit=20)
        expect_url(
          "http://panda.example.com/api/1.0/dataset/example/data/",
          :query => {
            "offset" => "20",
            "limit" => "20",
            "q" => "hello"
          })
      end

      it "handles page numbers" do
        @dataset.data_page(query = "hello", page_num = 3, rows_per_page = 50)
        expect_url(
          "http://panda.example.com/api/1.0/dataset/example/data/",
          :query => {
            "offset" => "150",
            "limit" => "50",
            "q" => "hello"
          })
      end
    end

    it "requires a search query" do
      client = make_test_client
      dataset = client.dataset("example")
      expect { dataset.search }.to raise_error(NotImplementedError)
    end

    it "passes additional search parameters when asked" do
      url = "http://panda.example.com/api/1.0/dataset/example/data/"
      query_params = {
        "format" => "json",
        "email" => "user@example.com",
        "api_key" => "API_KEY_HERE",
        "offset" => "0",
        "limit" => "100",
        "q" => "hello",
        "foo" => "bar"
      }

      stub_request(:get, url)
        .with(:query => query_params)
        .to_return(:body => '{"meta": {"next": null}, "objects": []}')

      client = make_test_client
      dataset = client.dataset("example")
      dataset.search("hello", {"foo" => "bar"})

      expect(WebMock).to have_requested(:get, url)
        .with(:query => query_params)
    end

    it "ends when no more rows exist" do
      url = "http://panda.example.com/api/1.0/dataset/example/data/"
      query_params = {
        "format" => "json",
        "email" => "user@example.com",
        "api_key" => "API_KEY_HERE",
        "offset" => "0",
        "limit" => "100",
        "q" => "hello"
      }
      stub_request(:get, url)
        .with(:query => query_params)
        .to_return(:body => '{"meta": {"next": "yep"}, "objects": []}')
      stub_request(:get, url)
        .with(:query => query_params.merge({"offset" => "100"}))
        .to_return(:body => '{"meta": {"next": null}, "objects": []}')

      client = make_test_client
      dataset = client.dataset("example")
      dataset.search("hello")

      expect(WebMock).to have_requested(:get, url)
        .with(:query => query_params)
      expect(WebMock).to have_requested(:get, url)
        .with(:query => query_params.merge({"offset" => "100"}))
    end
  end
end
