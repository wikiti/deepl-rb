# frozen_string_literal: true

module DeepL
  module Resources
    class Glossary < Base
      attr_reader :id, :name, :ready, :source_lang, :target_lang, :creation_time, :entry_count

      def initialize(glossary, *args)
        super(*args)

        @id = glossary['glossary_id']
        @name = glossary['name']
        @ready = glossary['ready']
        @source_lang = glossary['source_lang']
        @target_lang = glossary['target_lang']
        @creation_time = glossary['creation_time']
        @entry_count = glossary['entry_count']
      end

      def to_s
        "#{id} - #{name}"
      end
    end
  end
end
