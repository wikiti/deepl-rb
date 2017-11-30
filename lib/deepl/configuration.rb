module DeepL
  class Configuration
    ATTRIBUTES = %i[auth_key host].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(data = {})
      data.each { |key, value| send("#{key}=", value) }
      @auth_key ||= ENV['DEEPL_AUTH_KEY']
      @host ||= 'https://api.deepl.com'
    end

    def validate!
      raise Exceptions::Error, 'auth_key not provided' if auth_key.nil? || auth_key.empty?
    end

    def attributes
      ATTRIBUTES.map { |attr| [attr, send(attr)] }.to_h
    end

    def ==(other)
      attributes == other.attributes
    end
  end
end
