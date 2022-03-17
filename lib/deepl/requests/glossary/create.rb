# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class Create < Base
        attr_reader :name, :source_lang, :target_lang, :entries, :entries_format

        def initialize(api, name, source_lang, target_lang, entries, options = {})
          super(api, options)
          @name = name
          @source_lang = source_lang
          @target_lang = target_lang
          @entries = entries
          @entries_format = delete_option(:entries_format) || 'tsv'
        end

        def request
          payload = {
            name: name, source_lang: source_lang, target_lang: target_lang, entries: entries_to_tsv,
            entries_format: entries_format
          }
          build_glossary(*post(payload))
        end

        private

        def entries_to_tsv
          return entries if entries.is_a?(String)

          entries.reduce('') { |tsv, entry| "#{tsv}#{entry.first}\t#{entry.last}\n" }
        end

        def build_glossary(request, response)
          glossary = JSON.parse(response.body)
          Resources::Glossary.new(glossary, request, response)
        end

        def path
          'glossaries'
        end
      end
    end
  end
end
