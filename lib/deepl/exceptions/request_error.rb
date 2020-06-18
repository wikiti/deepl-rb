module DeepL
  module Exceptions
    class RequestError < Error
      attr_reader :request, :response

      def initialize(request, response)
        @request = request
        @response = response
      end

      def message
        'Unknown error.'
      end
    end
  end
end
