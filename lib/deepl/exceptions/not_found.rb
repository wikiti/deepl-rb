# frozen_string_literal: true

module DeepL
  module Exceptions
    class NotFound < RequestError
      def message
        JSON.parse(response.body)['message']
      rescue JSON::ParserError
        response.body
      end
    end
  end
end
