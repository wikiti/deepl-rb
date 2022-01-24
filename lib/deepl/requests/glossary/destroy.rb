# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class Destroy < Base
        attr_reader :id

        def initialize(api, id, options = {})
          super(api, options)
          @id = id
        end

        def request
          build_response(*delete)
        end

        private

        def build_response(_, _)
          id
        end

        def url
          "#{host}/#{api.configuration.version}/#{path}/#{id}"
        end

        def path
          'glossaries'
        end
      end
    end
  end
end
