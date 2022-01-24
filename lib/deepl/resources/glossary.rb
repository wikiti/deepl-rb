# frozen_string_literal: true

module DeepL
  module Resources
    class Glossary < Base
      attr_reader :id, :name, :ready, :source_lang, :target_lang, :creation_time, :entry_count

      def initialize(id, name, ready, source_lang, target_lang, creation_time, entry_count, *args)
        super(*args)

        @id = id
        @name = name
        @ready = ready
        @source_lang = source_lang
        @target_lang = target_lang
        @creation_time = creation_time
        @entry_count = entry_count
      end

      def entries
        DeepL.glossaries.entries(id)
      end

      def to_s
        "#{id} - #{name}"
      end
    end
  end
end
