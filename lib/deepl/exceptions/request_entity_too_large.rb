# frozen_string_literal: true

module DeepL
  module Exceptions
    class RequestEntityTooLarge < RequestError
      def message
        'The request size has reached the supported limit. ' \
          "Make sure that you're not sending more than 50 text parts."
      end
    end
  end
end
