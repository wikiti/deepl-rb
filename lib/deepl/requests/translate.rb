# frozen_string_literal: true

module DeepL
  module Requests
    class Translate < Base
      BOOLEAN_CONVERSION = { true => '1', false => '0' }.freeze
      ARRAY_CONVERSION = ->(value) { value.is_a?(Array) ? value.join(', ') : value }.freeze
      NO_CONVERSION = ->(value) { value }
      OPTIONS_CONVERSIONS = {
        split_sentences: BOOLEAN_CONVERSION,
        preserve_formatting: BOOLEAN_CONVERSION,
        non_splitting_tags: ARRAY_CONVERSION,
        ignore_tags: ARRAY_CONVERSION,
        glossary_id: NO_CONVERSION,
      }.freeze

      attr_reader :text, :source_lang, :target_lang, :ignore_tags, :non_splitting_tags, :glossary_id

      def initialize(api, text, source_lang, target_lang, options = {})
        super(api, options)
        @text = text
        @source_lang = source_lang
        @target_lang = target_lang
        @glossary_id = options[:glossary_id]

        tweak_parameters!
      end

      def request
        payload = { text: text, source_lang: source_lang, target_lang: target_lang }
        payload.merge!({ glossary_id: glossary_id }) if glossary_id.present?

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
