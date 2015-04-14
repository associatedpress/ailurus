require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  it "initializes properly" do
    dataset = Ailurus::Dataset.new(:client, "slug")

    expect(dataset.client).to eq(:client)
    expect(dataset.slug).to eq("slug")
  end

  context "hits the correct endpoints" do
    before(:each) do
      stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
      stub_request(
        :any, /panda\.example\.com\/api\/1\.0\/dataset\/example\/data\//
      ).to_return(:body => '{"objects": [], "meta": {"next": "yes please"}}')

      @client = Ailurus::Client.new(
        :api_key => "API_KEY_HERE",
        :domain => "panda.example.com",
        :email => "user@example.com"
      )
      @slug = "example"
      @dataset = Ailurus::Dataset.new(@client, @slug)
    end

    it "hits the metadata endpoint" do
      @dataset.metadata
      expect_url("http://panda.example.com/api/1.0/dataset/example/")
    end

    it "handles row offset/limit" do
      @dataset.data_rows(query = "hello", offset = 20, limit=20)
      expect_url(
        "http://panda.example.com/api/1.0/dataset/example/data/",
        :get,
        {
          "offset" => "20",
          "limit" => "20",
          "q" => "hello"
        })
    end

    it "handles page numbers" do
      @dataset.data_page(query = "hello", page_num = 3, rows_per_page = 50)
      expect_url(
        "http://panda.example.com/api/1.0/dataset/example/data/",
        :get,
        {
          "offset" => "150",
          "limit" => "50",
          "q" => "hello"
        })
    end
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

    client = Ailurus::Client.new(
      :api_key => "API_KEY_HERE",
      :domain => "panda.example.com",
      :email => "user@example.com"
    )
    dataset = client.dataset("example")
    dataset.search("hello")

    expect(WebMock).to have_requested(:get, url)
      .with(:query => query_params)
    expect(WebMock).to have_requested(:get, url)
      .with(:query => query_params.merge({"offset" => "100"}))
  end

  it "requires a search query" do
    client = Ailurus::Client.new(
      :api_key => "API_KEY_HERE",
      :domain => "panda.example.com",
      :email => "user@example.com"
    )
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

    client = Ailurus::Client.new(
      :api_key => "API_KEY_HERE",
      :domain => "panda.example.com",
      :email => "user@example.com"
    )
    dataset = client.dataset("example")
    dataset.search("hello", {"foo" => "bar"})

    expect(WebMock).to have_requested(:get, url)
      .with(:query => query_params)
  end

  context "may be created" do
    before(:each) do
      stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
    end

    it "works with no other parameters" do
      client = Ailurus::Client.new(
        :api_key => "API_KEY_HERE",
        :domain => "panda.example.com",
        :email => "user@example.com"
      )
      dataset = client.dataset("example")
      dataset.create

      expect_url(
        "http://panda.example.com/api/1.0/dataset/",
        :post,
        {
          "name" => "example",
          "slug" => "example"
        })
    end
  end
end
