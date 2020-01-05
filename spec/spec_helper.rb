ENV["APP_ENV"] ||= "test"

require File.expand_path("../../config/initialize", __FILE__)
require File.expand_path("../../config/application", __FILE__)

require "rack/test"
require "webmock/rspec"
require "faktory/testing"

module RspecHelperMethods
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file("config.ru").first
  end

  def last_response_json
    JSON.parse(last_response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation

    Faktory::Testing.fake!
  end

  config.after(:suite) do
    Faktory::Testing.disable!
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end

    Faktory::Queues.clear_all
  end

  config.before(:all) do
    FFaker::Random.seed = config.seed
  end

  config.before(:each) do
    FFaker::Random.reset!
  end

  config.include FactoryBot::Syntax::Methods
  config.include RspecHelperMethods

  FactoryBot.definition_file_paths = [
    File.expand_path("../factories", __FILE__)
  ]

  FactoryBot.find_definitions

  WebMock.disable_net_connect!
end
