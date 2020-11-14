# frozen_string_literal: true

module DeepL
  class API
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      configuration.validate!
    end
  end
end
