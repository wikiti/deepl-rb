# frozen_string_literal: true

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake'
require 'juwelier'

Juwelier::Tasks.new do |gem|
  gem.name = 'deepl-rb'
  gem.homepage = 'http://github.com/wikiti/deepl-rb'
  gem.license = 'MIT'
  gem.summary = 'A simple ruby wrapper for the DeepL API'
  gem.description =
    'A simple ruby wrapper for the DeepL translation API (v1). ' \
    'For more information, check this: https://www.deepl.com/docs/api-reference.html'

  gem.email = 'info@danielherzog.es'
  gem.authors = ['Daniel Herzog']
end

Juwelier::RubygemsDotOrgTasks.new

# Tests
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

desc 'Run all tests.'
task :test do
  Rake::Task['spec'].invoke
  Rake::Task['rubocop'].invoke
end

task default: :test
