# frozen_string_literal: true

module DeepL
  module Requests
    class Glossary < Base
      attr_reader :name, :entries, :source_lang, :target_lang

      def initialize(api, name, entries, source_lang, target_lang, options = {})
        super(api, options)
        @name = name
        @entries = entries
        @source_lang = source_lang
        @target_lang = target_lang
      end

      def request
        payload = {
          name: name,
          entries: entries,
          source_lang: source_lang,
          target_lang: target_lang,
          entries_format: 'tsv'
        }
        build_glossary(*post(payload))
      end

      private

      def build_glossary(request, response)
        data = JSON.parse(response.body)
        Resources::Glossary.new(data['glossary_id'], data['name'], request, response)
      end

      def path
        'glossaries'
      end
    end
  end
end
