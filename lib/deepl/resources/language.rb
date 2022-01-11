# frozen_string_literal: true

module DeepL
  module Resources
    class Language < Base
      attr_reader :code, :name

      def initialize(code, name, supports_formality = nil, *args)
        super(*args)

        @code = code
        @name = name
        return if supports_formality.nil?

        @supports_formality = supports_formality
        define_singleton_method(:supports_formality) do
          @supports_formality
        end
      end

      def to_s
        "#{code} - #{name}"
      end
    end
  end
end
