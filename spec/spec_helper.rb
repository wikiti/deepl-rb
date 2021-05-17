# frozen_string_literal: true

# Coverage
require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

# Load lib
require_relative '../lib/deepl'

# Lib config
ENV['DEEPL_AUTH_KEY'] ||= 'TEST-TOKEN'

# VCR tapes configuration
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('VALID_TOKEN') { ENV['DEEPL_AUTH_KEY'] }
  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: %i[method uri body]
  }
end

# General helpers
def build_deepl_api
  DeepL::API.new(DeepL::Configuration.new(host: 'https://api-free.deepl.com'))
end
