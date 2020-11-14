# frozen_string_literal: true

module DeepL
  module Exceptions
    class AuthorizationFailed < RequestError
      def message
        'Authorization failed. Please supply a valid auth_key parameter.'
      end
    end
  end
end
