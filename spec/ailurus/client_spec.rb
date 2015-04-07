require "spec_helper"

require "ailurus/client"

describe Ailurus::Client do
  it "initializes properly" do
    client = Ailurus::Client.new({
      :api_key => "api key",
      :domain => "domain name",
      :email => "email address"
    })

    expect(client.api_key).to eq("api key")
    expect(client.domain).to eq("domain name")
    expect(client.email).to eq("email address")
  end
end
