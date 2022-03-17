# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class Find < Base
        attr_reader :id

        def initialize(api, id, options = {})
          super(api, options)
          @id = id
        end

        def request
          build_glossary(*get)
        end

        private

        def build_glossary(request, response)
          glossary = JSON.parse(response.body)
          Resources::Glossary.new(glossary, request, response)
        end

        def path
          "glossaries/#{id}"
        end
      end
    end
  end
end
