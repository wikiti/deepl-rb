module DeepL
  module Requests
    class TranslateText < Base
      attr_reader :text, :source_lang, :target_lang

      def initialize(api, text, source_lang, target_lang, options = {})
        super(api, options)
        @text = text
        @source_lang = source_lang
        @target_lang = target_lang
      end

      def request
        payload = { text: text, source_lang: source_lang, target_lang: target_lang }
        build_texts(*post(payload))
      end

      private

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
