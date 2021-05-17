# frozen_string_literal: true

module DeepL
  module Resources
    class Language < Base
      attr_reader :code, :name

      def initialize(code, name, *args)
        super(*args)

        @code = code
        @name = name
      end

      def to_s
        "#{code} - #{name}"
      end
    end
  end
end
