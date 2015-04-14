$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "climate_control"
require "webmock/rspec"

require "ailurus"

def expect_url(url, method = :get, payload = {})
  query = {
    "format" => "json",
    "email" => "user@example.com",
    "api_key" => "API_KEY_HERE"
  }
  if method == :get
    query.merge!(payload)
    expectation = {
      :query => query.merge(payload)
    }
  else
    expectation = {
      :query => query,
      :body => JSON.generate(payload)
    }
  end

  expect(WebMock).to have_requested(method, url).with(expectation)
end
