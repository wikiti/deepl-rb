# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class LanguagePairs < Base
        def initialize(api, options = {})
          super(api, options)
        end

        def request
          build_language_pair_list(*get)
        end

        private

        def build_language_pair_list(request, response)
          data = JSON.parse(response.body)
          data['supported_languages'].map do |language_pair|
            Resources::LanguagePair.new(language_pair['source_lang'], language_pair['target_lang'],
                                        request, response)
          end
        end

        def path
          'glossary-language-pairs'
        end
      end
    end
  end
end
