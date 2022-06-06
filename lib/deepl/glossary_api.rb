# frozen_string_literal: true

module DeepL
  class GlossaryApi
    def initialize(api, options = {})
      @api = api
      @options = options
    end

    def create(name, source_lang, target_lang, entries, options = {})
      DeepL::Requests::Glossary::Create.new(@api, name, source_lang, target_lang, entries, options)
                                       .request
    end

    def destroy(glossary_id, options = {})
      DeepL::Requests::Glossary::Destroy.new(@api, glossary_id, options).request
    end

    def entries(glossary_id, options = {})
      DeepL::Requests::Glossary::Entries.new(@api, glossary_id, options).request
    end

    def find(glossary_id, options = {})
      DeepL::Requests::Glossary::Find.new(@api, glossary_id, options).request
    end

    def language_pairs(options = {})
      DeepL::Requests::Glossary::LanguagePairs.new(@api, options).request
    end

    def list(options = {})
      DeepL::Requests::Glossary::List.new(@api, options).request
    end
  end
end
