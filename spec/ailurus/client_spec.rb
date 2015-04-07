require "spec_helper"

require "ailurus/client"

describe Ailurus::Client do
  it "initializes properly" do
    client = Ailurus::Client.new(
      :api_key => "api key",
      :domain => "domain name",
      :email => "email address"
    )

    expect(client.api_key).to eq("api key")
    expect(client.domain).to eq("domain name")
    expect(client.email).to eq("email address")
  end

  it "adds authentication parameters to requests" do
    stub_request(:any, /panda\.example\.com/).to_return(:body => "{}")

    client = Ailurus::Client.new(
      :api_key => "API_KEY_HERE",
      :domain => "panda.example.com",
      :email => "user@example.com"
    )
    example_dataset = client.dataset("example")

    expected_url = "http://panda.example.com/api/1.0/dataset/example/"
    expect(WebMock).to have_requested(:get, expected_url).with(:query => {
      "format" => "json",
      "email" => "user@example.com",
      "api_key" => "API_KEY_HERE"
    })
  end
end
