[![Gem Version](https://badge.fury.io/rb/deepl-rb.svg)](https://badge.fury.io/rb/deepl-rb) [![CircleCI](https://circleci.com/gh/wikiti/deepl-rb.svg?style=shield)](https://circleci.com/gh/wikiti/deepl-rb) [![CodeCov](https://codecov.io/gh/wikiti/deepl-rb/branch/master/graph/badge.svg?token=SHLgQNlZ4o)](https://codecov.io/gh/wikiti/deepl-rb)

# DeepL for ruby

A simple ruby wrapper for the [DeepL translation API (v2)](https://www.deepl.com/api.html).

## Installation

Install this gem with

```sh
gem install deepl-rb
# Load it in your ruby file using `require 'deepl'`
```

Or add it to your Gemfile:

```rb
gem 'deepl-rb', require: 'deepl'
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

You can also configure the API host and the API version:

```rb
DeepL.configure do |config|
  config.auth_key = 'your-api-token'
  config.host = 'https://api-free.deepl.com' # Default value is 'https://api.deepl.com'
  config.version = 'v1' # Default value is 'v2'
end
```

### Available languages

Available languages can be retrieved via API:

```rb
languages = DeepL.languages

puts languages.class
# => Array
puts languages.first.class
# => DeepL::Resources::Language
puts "#{languages.first.code} -> #{languages.first.name}"
# => "ES -> Spanish"
```

Note that source and target languages may be different, which can be retrieved by using the `type`
option:

```rb
puts DeepL.languages(type: :source).count
# => 24
puts DeepL.languages(type: :target).count
# => 26
```

All languages are also defined on the
[official API documentation](https://www.deepl.com/docs-api/translating-text/).

Note that target languages may include the `supports_formality` flag, which may be checked
using the `DeepL::Resources::Language#supports_formality?`.

### Translate

To translate a simple text, use the `translate` method:

```rb
translation = DeepL.translate 'This is my text', 'EN', 'ES'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => 'Este es mi texto'
```

Enable auto-detect source language by skipping the source language with `nil`:

```rb
translation = DeepL.translate 'This is my text', nil, 'ES'

puts translation.detected_source_language
# => 'EN'
```

Translate a list of texts by passing an array as an argument:

```rb
texts = ['Sample text', 'Another text']
translations = DeepL.translate texts, 'EN', 'ES'

puts translations.class
# => Array
puts translations.first.class
# => DeepL::Resources::Text
```

You can also use custom query parameters, like `tag_handling`, `split_sentences`, `non_splitting_tags` or `ignore_tags`:

```rb
translation = DeepL.translate '<p>A sample</p>', 'EN', 'ES',
                              tag_handling: 'xml', split_sentences: false,
                              non_splitting_tags: 'h1', ignore_tags: %w[code pre]

puts translation.text
# => "<p>Una muestra</p>"
```

The following parameters will be automatically converted:

| Parameter             | Conversion
| --------------------- | ---------------
| `preserve_formatting` | Converts `false` to `'0'` and `true` to `'1'`
| `split_sentences`     | Converts `false` to `'0'` and `true` to `'1'`
| `outline_detection`   | Converts `false` to `'0'` and `true` to `'1'`
| `splitting_tags`      | Converts arrays to strings joining by commas
| `non_splitting_tags`  | Converts arrays to strings joining by commas
| `ignore_tags`         | Converts arrays to strings joining by commas
| `formality`           | No conversion applied
| `glossary_id`         | No conversion applied

### Glossaries

To create a glossary, use the `glossaries.create` method. The glossary `entries` argument should be an array of text pairs. Each pair includes the source and the target translations.

```rb
entries = [
  ['Hello World', 'Hola Tierra'],
  ['car', 'auto']
]
glossary = DeepL.glossaries.create 'Mi Glosario', 'EN', 'ES', entries

puts glossary.class
# => DeepL::Resources::Glossary
puts glossary.id
# => 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'
puts glossary.entry_count
# => 2
```

Created glossaries can be used in the `translate` method by specifying the `glossary_id` option:

```rb
translation = DeepL.translate 'Hello World', 'EN', 'ES', glossary_id: 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => 'Hola Tierra'

translation = DeepL.translate "I wish we had a car.", 'EN', 'ES', glossary_id: 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => Ojalá tuviéramos un auto.
```

To list all the glossaries available, use the `glossaries.list` method:

```rb
glossaries = DeepL.glossaries.list

puts glossaries.class
# => Array
puts glossaries.first.class
# => DeepL::Resources::Glossary
```

To find an existing glossary, use the `glossaries.find` method:

```rb
glossary = DeepL.glossaries.find 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts glossary.class
# => DeepL::Resources::Glossary
```

The glossary resource does not include the glossary entries. To list the glossary entries, use the `glossaries.entries` method:

```rb
entries = DeepL.glossaries.entries 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts entries.class
# => Array
puts entries.size
# => 2
pp entries.first
# => ["Hello World", "Hola Tierra"]
```

To delete an existing glossary, use the `glossaries.destroy` method:

```rb
glossary_id = DeepL.glossaries.destroy 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts glossary_id
# => aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e
```

You can list all the language pairs supported by glossaries using the `glossaries.language_pairs` method:

```rb
language_pairs = DeepL.glossaries.language_pairs

puts language_pairs.class
# => Array
puts language_pairs.first.class
# => DeepL::Resources::LanguagePair
puts language_pairs.first.source_lang
# => en
puts language_pairs.first.target_lang
# => de
```

### Monitor usage

To check current API usage, use:

```rb
usage = DeepL.usage

puts usage.character_count
# => 180118
puts usage.character_limit
# => 1250000
```

### Handle exceptions

You can capture and process exceptions that may be raised during API calls. These are all the possible exceptions:

| Exception class | Description |
| --------------- | ----------- |
| `DeepL::Exceptions::AuthorizationFailed` | The authorization process has failed. Check your `auth_key` value. |
| `DeepL::Exceptions::BadRequest` | Something is wrong in your request. Check `exception.message` for more information. |
| `DeepL::Exceptions::LimitExceeded` | You've reached the API's call limit. |
| `DeepL::Exceptions::QuotaExceeded` | You've reached the API's character limit. |
| `DeepL::Exceptions::RequestError` | An unkown request error. Check `exception.response` and `exception.request` for more information. |
| `DeepL::Exceptions::NotSupported` | The requested method or API endpoint is not supported. |

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

## Integrations

### Ruby on Rails

You may use this gem as a standalone service by creating an initializer on your
`config/initializers` folder with your DeepL configuration. For example:

```rb
# config/initializers/deepl.rb
DeepL.configure do |config|
  # Your configuration goes here
end
```

Since the DeepL service is defined globally, you can use service anywhere in your code
(controllers, models, views, jobs, plain ruby objects… you name it).

### i18n-tasks

You may also take a look at [`i18n-tasks`](https://github.com/glebm/i18n-tasks), which is a gem
that helps you find and manage missing and unused translations. `deepl-rb` is used as one of the
backend services to translate content.

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
