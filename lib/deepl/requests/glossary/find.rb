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

        def url
          "#{host}/#{api.configuration.version}/#{path}/#{id}"
        end

        def build_glossary(request, response)
          glossary = JSON.parse(response.body)
          Resources::Glossary.new(glossary['glossary_id'], glossary['name'], glossary['ready'],
                                  glossary['source_lang'], glossary['target_lang'],
                                  glossary['creation_time'], glossary['entry_count'],
                                  request, response)
        end

        def path
          'glossaries'
        end
      end
    end
  end
end
