require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  context "may be updated" do
    before(:each) do
      stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
      @client = make_test_client
      @dataset = @client.dataset("example")
    end

    it "accepts one row" do
      rows = [
        {
          "data" => ["a", "b", "c"]
        }
      ]
      @dataset.update(rows)

      expect_url(
        "http://panda.example.com/api/1.0/dataset/example/data/",
        :method => :put,
        :body => {
          "objects" => rows
        }
      )
    end

    it "accepts multiple rows" do
      rows = [
        {
          "data" => ["a", "b", "c"]
        },
        {
          "data" => ["d", "e", "f"]
        }
      ]
      @dataset.update(rows)

      expect_url(
        "http://panda.example.com/api/1.0/dataset/example/data/",
        :method => :put,
        :body => {
          "objects" => rows
        }
      )
    end
  end
end
