# frozen_string_literal: true

# -- Dependencies
require 'json'
require 'net/http'

# -- Exceptions
require 'deepl/exceptions/error'
require 'deepl/exceptions/request_error'
require 'deepl/exceptions/authorization_failed'
require 'deepl/exceptions/bad_request'
require 'deepl/exceptions/limit_exceeded'
require 'deepl/exceptions/quota_exceeded'

# -- Requests
require 'deepl/requests/base'
require 'deepl/requests/languages'
require 'deepl/requests/translate'
require 'deepl/requests/usage'

# -- Responses and resources
require 'deepl/resources/base'
require 'deepl/resources/language'
require 'deepl/resources/text'
require 'deepl/resources/usage'

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

  def languages(options = {})
    Requests::Languages.new(api, options).request
  end

  def translate(text, source_lang, target_lang, options = {})
    configure if @configuration.nil?
    Requests::Translate.new(api, text, source_lang, target_lang, options).request
  end

  def usage(options = {})
    configure if @configuration.nil?
    Requests::Usage.new(api, options).request
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
