# -- Dependencies
require 'json'
require 'net/http'

# -- Exceptions
require 'deepl/exceptions/error'
require 'deepl/exceptions/request_error'
require 'deepl/exceptions/authorization_failed'
require 'deepl/exceptions/bad_request'
require 'deepl/exceptions/limit_exceeded'

# -- Requests
require 'deepl/requests/base'
require 'deepl/requests/translate_text'

# -- Responses and resources
require 'deepl/resources/base'
require 'deepl/resources/text'

# -- Other wrappers
require 'deepl/api'
require 'deepl/configuration'

# -- Gem interface
module DeepL
  extend self

  ## -- API shortcuts

  def api
    @api ||= API.new(configuration)
  end

  def translate(text, source_lang, target_lang, options = {})
    configure if @configuration.nil?
    Requests::TranslateText.new(api, text, source_lang, target_lang, options).request
  end

  # -- Configuration

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration if block_given?
    configuration.validate!
  end
end
