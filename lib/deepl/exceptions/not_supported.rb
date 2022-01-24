# frozen_string_literal: true

module DeepL
  module Exceptions
    class NotSupported < Error
      def initialize(msg = 'The feature is not supported')
        super
      end
    end
  end
end
