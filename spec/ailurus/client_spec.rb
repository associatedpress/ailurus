require "spec_helper"

require "ailurus/client"

describe Ailurus::Client do
  context "initializes properly" do
    it "accepts config arguments" do
      client = Ailurus::Client.new(
        :api_key => "api key",
        :domain => "domain name",
        :email => "email address"
      )

      expect(client.api_key).to eq("api key")
      expect(client.domain).to eq("domain name")
      expect(client.email).to eq("email address")
    end

    it "accepts environment variables" do
      ClimateControl.modify PANDA_API_KEY: "api key", PANDA_DOMAIN: "domain name", PANDA_EMAIL: "email address" do
        client = Ailurus::Client.new

        expect(client.api_key).to eq("api key")
        expect(client.domain).to eq("domain name")
        expect(client.email).to eq("email address")
      end
    end
  end

  it "adds authentication parameters to requests" do
    stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")

    client = Ailurus::Client.new(
      :api_key => "API_KEY_HERE",
      :domain => "panda.example.com",
      :email => "user@example.com"
    )
    client.make_request("/")

    expected_url = "http://panda.example.com/"
    expect(WebMock).to have_requested(:get, expected_url).with(:query => {
      "format" => "json",
      "email" => "user@example.com",
      "api_key" => "API_KEY_HERE"
    })
  end
end
