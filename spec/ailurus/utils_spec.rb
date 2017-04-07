require "spec_helper"

require "ailurus/utils"

describe Ailurus::Utils do
  context "get_absolute_uri works as expected" do
    it "handles bare domains" do
      test_uri = Ailurus::Utils::get_absolute_uri("panda.example.com")

      expect(test_uri.scheme).to eq("http")
      expect(test_uri.host).to eq("panda.example.com")
    end

    it "handles bare domains with ports" do
      test_uri = Ailurus::Utils::get_absolute_uri("panda.example.com:8080")

      expect(test_uri.scheme).to eq("http")
      expect(test_uri.host).to eq("panda.example.com")
      expect(test_uri.port).to eq(8080)
    end

    it "handles bare IPv4 addresses" do
      test_uri = Ailurus::Utils::get_absolute_uri("127.0.0.1")

      expect(test_uri.scheme).to eq("http")
      expect(test_uri.host).to eq("127.0.0.1")
    end

    it "handles bare IPv4 addresses with ports" do
      test_uri = Ailurus::Utils::get_absolute_uri("127.0.0.1:8080")

      expect(test_uri.scheme).to eq("http")
      expect(test_uri.host).to eq("127.0.0.1")
      expect(test_uri.port).to eq(8080)
    end

    it "handles domains with HTTP" do
      test_uri = Ailurus::Utils::get_absolute_uri("http://panda.example.com")

      expect(test_uri.scheme).to eq("http")
      expect(test_uri.host).to eq("panda.example.com")
    end

    it "handles domains with HTTPS" do
      test_uri = Ailurus::Utils::get_absolute_uri("https://panda.example.com")

      expect(test_uri.scheme).to eq("https")
      expect(test_uri.host).to eq("panda.example.com")
    end

    it "handles domains with schemes and ports" do
      test_uri = Ailurus::Utils::get_absolute_uri(
        "http://panda.example.com:8080")

      expect(test_uri.scheme).to eq("http")
      expect(test_uri.host).to eq("panda.example.com")
      expect(test_uri.port).to eq(8080)
    end
  end
end
