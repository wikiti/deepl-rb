[![Gem Version](https://badge.fury.io/rb/deepl-rb.svg)](https://badge.fury.io/rb/deepl-rb) [![Dependency Status](https://gemnasium.com/badges/github.com/wikiti/deepl-rb.svg)](https://gemnasium.com/github.com/wikiti/deepl-rb) [![CircleCI](https://circleci.com/gh/wikiti/deepl-rb.svg?style=shield)](https://circleci.com/gh/wikiti/deepl-rb) [![CodeCov](https://codecov.io/gh/wikiti/deepl-rb/branch/master/graph/badge.svg?token=SHLgQNlZ4o)](https://codecov.io/gh/wikiti/deepl-rb)

# DeepL for ruby

A simple ruby wrapper for the [DeepL translation API (v1)](https://www.deepl.com/docs/api-reference.html).

## Installation

Install this gem with

```sh
gem install deepl-rb
```

Or add it to your Gemfile:

```rb
gem 'deepl-rb'
```

## Usage

Setup an environment variable named `DEEPL_AUTH_KEY` with your authentication key:

```sh
export DEEPL_AUTH_KEY="your-api-token"
```

Alternatively, you can configure the API client within a ruby block:

```rb
DeepL.configure do |config|
  config.auth_key = 'your-api-token'
end
```

You can also configure the api host:

```rb
DeepL.configure do |config|
  config.auth_key = 'your-api-token'
  config.host = 'https://test-api.deepl.com' # Default value is 'https://api.deepl.com'
end
```

### Translate

To translate a simple text, use the `translate` method:

```rb
item = DeepL.translate 'This is my text', 'EN', 'ES'

puts item.class
# => DeepL::Resources::Text
puts item.text
# => 'Este es mi texto'
```

You can also auto-detect source language by skipping it with `nil`:

```rb
item = DeepL.translate 'This is my text', nil, 'ES'

puts item.detected_source_language
# => 'EN'
```

You can also translate a list of texts by passing an array as an argument:

```rb
texts = ['Sample text', 'Another text']
items = DeepL.translate texts, 'EN', 'ES'

puts items.class
# => Array
puts items.first.class
# => DeepL::Resources::Text
```

Here's a list of available language codes:

| Language code   | Language
| --------------- | ---------------
| `EN`            | English
| `DE`            | German
| `FR`            | French
| `ES`            | Spanish
| `IT`            | Italian
| `NL`            | Dutch
| `PL`            | Polish

### Handle exceptions

You can capture and process exceptions that may be raised during API calls. These are all the possible exceptions:

| Exception class | Descripcion |
| --------------- | ----------- |
| `DeepL::Exceptions::AuthorizationFailed` | The authorization process has failed. Check your auth_key value. |
| `DeepL::Exceptions::BadRequest` | Something is wrong in your request. Check `exception.message` for more information. |
| `DeepL::Exceptions::LimitExceeded` | You've reached the API's call limit. |
| `DeepL::Exceptions::RequestError` | An unkown request error. Check `exception.response` and `exception.request` for more information. |

An exampling of handling a generic exception:

```rb
def my_method
  item = DeepL.translate 'This is my text', nil, 'ES'
rescue DeepL::Exceptions::RequestError => e
  puts 'Oops!'
  puts "Code: #{e.response.code}"
  puts "Response body: #{e.response.body}"
  puts "Request body: #{e.request.body}"
end

```

## Development

Clone the repository, and install its dependencies:

```sh
git clone https://github.com/wikiti/deepl-rb
cd deepl-rb
bundle install
```

To run tests (rspec and rubocop), use

```
bundle exec rake test
```

## Contributors

This project has been developed by:

| Avatar | Name | Nickname | Email |
| ------ | ---- | -------- | ----- |
| ![](http://www.gravatar.com/avatar/2ae6d81e0605177ba9e17b19f54e6b6c.jpg?s=64)  | Daniel Herzog | Wikiti | [info@danielherzog.es](mailto:info@danielherzog.es)
