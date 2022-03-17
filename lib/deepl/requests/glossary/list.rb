# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class List < Base
        def initialize(api, options = {})
          super(api, options)
        end

        def request
          build_glossary_list(*get)
        end

        private

        def build_glossary_list(request, response)
          data = JSON.parse(response.body)
          data['glossaries'].map do |glossary|
            Resources::Glossary.new(glossary, request, response)
          end
        end

        def path
          'glossaries'
        end
      end
    end
  end
end
