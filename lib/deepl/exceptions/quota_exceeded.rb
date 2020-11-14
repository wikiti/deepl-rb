# frozen_string_literal: true

module DeepL
  module Exceptions
    class QuotaExceeded < RequestError
      def message
        'Quota exceeded. The character limit has been reached.'
      end
    end
  end
end
