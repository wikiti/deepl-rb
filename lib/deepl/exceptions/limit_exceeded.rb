# frozen_string_literal: true

module DeepL
  module Exceptions
    class LimitExceeded < RequestError
      def message
        'Limit exceeded. Please wait and send your request once again.'
      end
    end
  end
end
