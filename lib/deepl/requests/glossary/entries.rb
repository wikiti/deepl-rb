# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class Entries < Base
        attr_reader :id

        def initialize(api, id, options = {})
          super(api, options)
          @id = id
        end

        def request
          build_entries(*get)
        end

        private

        def url
          "#{host}/#{api.configuration.version}/#{path}/#{id}/entries"
        end

        def build_entries(_, response)
          response.body.split("\n").map { |entry| entry.split("\t") }
        end

        def path
          'glossaries'
        end
      end
    end
  end
end
