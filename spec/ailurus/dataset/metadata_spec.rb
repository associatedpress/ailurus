require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  context "handles metadata" do
    it "hits the metadata endpoint" do
      stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
      make_test_client.dataset("example").metadata
      expect_url("http://panda.example.com/api/1.0/dataset/example/")
    end

    it "looks up indexed field names" do
      stub_request(:any, /panda\.example\.com/).to_return(
        :body => JSON.generate({
          "column_schema" => [{
            "name" => "alfa", "indexed_name" => "column_unicode_alfa"}]}))

      client = make_test_client
      dataset = client.dataset("example")

      test_name = dataset.get_indexed_name("alfa")
      expect(test_name).to eq("column_unicode_alfa")
    end
  end
end
