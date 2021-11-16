# frozen_string_literal: true

source 'https://rubygems.org'

group :development do
  # Gem management
  gem 'juwelier'
end

group :test, :development do
  gem 'pry-byebug', platforms: %i[mri mingw x64_mingw]
end

group :test do
  # Test
  gem 'codecov', require: false
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end
