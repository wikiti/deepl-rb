module DeepL
  module Requests
    class TranslateText < Base
      OPTIONS_CONVERSIONS = {
        split_sentences: { true => '1', false => '0' },
        preserve_formatting: { true => '1', false => '0' }
      }.freeze

      attr_reader :text, :source_lang, :target_lang

      def initialize(api, text, source_lang, target_lang, options = {})
        super(api, options)
        @text = text
        @source_lang = source_lang
        @target_lang = target_lang

        tweak_parameters!
      end

      def request
        payload = { text: text, source_lang: source_lang, target_lang: target_lang }
        build_texts(*post(payload))
      end

      private

      def tweak_parameters!
        OPTIONS_CONVERSIONS.each do |param, converter|
          next unless option?(param) && converter[option(param)]
          set_option(param, converter[option(param)])
        end
      end

      def build_texts(request, response)
        data = JSON.parse(response.body)

        texts = data['translations'].map do |translation|
          Resources::Text.new(translation['text'], translation['detected_source_language'],
                              request, response)
        end

        texts.size == 1 ? texts.first : texts
      end

      def path
        'translate'
      end
    end
  end
end
