# frozen_string_literal: true

module DeepL
  module Resources
    class LanguagePair < Base
      attr_reader :source_lang, :target_lang

      def initialize(source_lang, target_lang, *args)
        super(*args)

        @source_lang = source_lang
        @target_lang = target_lang
      end

      def to_s
        "#{source_lang} - #{target_lang}"
      end
    end
  end
end
