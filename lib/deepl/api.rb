module DeepL
  class API
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      configuration.validate!
    end
  end
end
