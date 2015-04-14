$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "climate_control"
require "webmock/rspec"

require "ailurus"

def expect_url(url, method = :get, params = {})
  content_key = case method
                when :get then :query
                else :body
                end

  expect(WebMock).to have_requested(method, url).with(content_key => {
    "format" => "json",
    "email" => "user@example.com",
    "api_key" => "API_KEY_HERE"
  }.merge(params))
end
