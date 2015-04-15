require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  context "may be created" do
    before(:each) do
      stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
    end

    it "works with no other parameters" do
      client = make_test_client
      dataset = client.dataset("example")
      dataset.create

      expect_url(
        "http://panda.example.com/api/1.0/dataset/",
        :method => :post,
        :body => {
          "name" => "example",
          "slug" => "example"
        })
    end

    it "includes column info in the query" do
      client = make_test_client
      dataset = client.dataset("example")
      dataset.create([
        {:name => "test"}
      ])

      expect_url(
        "http://panda.example.com/api/1.0/dataset/",
        :method => :post,
        :body => {
          "name" => "example",
          "slug" => "example"
        },
        :query => {
          "columns" => "test",
          "column_types" => "unicode",
          "typed_columns" => "false"
        })
    end
  end
end
