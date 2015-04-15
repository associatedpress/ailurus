$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "json"

require "climate_control"
require "webmock/rspec"

require "ailurus"

TEST_CLIENT_PARAMS = {
  :domain => "panda.example.com",
  :email => "user@example.com",
  :api_key => "API_KEY_HERE"
}

def expect_url(url, options = {})
  # Handle default option values.
  query = options.fetch(:query, {})
  method = options.fetch(:method, :get)
  body = options.fetch(:body, nil)

  auth_params = {
    "format" => "json",
    "email" => TEST_CLIENT_PARAMS[:email],
    "api_key" => TEST_CLIENT_PARAMS[:api_key]
  }
  query = auth_params.merge(query)

  expectation = {
    :query => query
  }
  if not body.nil?
    expectation[:body] = JSON.generate(body)
    expectation[:headers] = {
      "Content-Type" => "application/json"
    }
  end

  expect(WebMock).to have_requested(method, url).with(expectation)
end

def make_test_client(client_params = TEST_CLIENT_PARAMS)
  Ailurus::Client.new(TEST_CLIENT_PARAMS)
end
