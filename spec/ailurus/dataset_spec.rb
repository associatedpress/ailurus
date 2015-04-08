require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  it "initializes properly" do
    dataset = Ailurus::Dataset.new(:client, "slug")

    expect(dataset.client).to eq(:client)
    expect(dataset.slug).to eq("slug")
  end

  context "hits the correct endpoints" do
    def expect_url(url, method = :get, params = {})
      expect(WebMock).to have_requested(method, url).with(:query => {
        "format" => "json",
        "email" => "user@example.com",
        "api_key" => "API_KEY_HERE"
      }.merge(params))
    end

    before(:each) do
      stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")
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
  end
end
