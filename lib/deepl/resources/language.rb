# frozen_string_literal: true

module DeepL
  module Resources
    class Language < Base
      attr_reader :code, :name

      def initialize(code, name, supports_formality, *args)
        super(*args)

        @code = code
        @name = name
        @supports_formality = supports_formality
      end

      def to_s
        "#{code} - #{name}"
      end

      def supports_formality?
        return @supports_formality unless @supports_formality.nil?

        raise Exceptions::NotSupported, 'Support formality is only available on target languages'
      end
    end
  end
end
