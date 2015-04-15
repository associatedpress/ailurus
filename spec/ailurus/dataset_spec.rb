require "spec_helper"

require "ailurus/dataset"

describe Ailurus::Dataset do
  it "initializes properly" do
    dataset = Ailurus::Dataset.new(:client, "slug")

    expect(dataset.client).to eq(:client)
    expect(dataset.slug).to eq("slug")
  end
end
