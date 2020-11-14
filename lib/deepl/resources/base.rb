# frozen_string_literal: true

module DeepL
  module Resources
    class Base
      attr_reader :request, :response

      def initialize(request, response)
        @request = request
        @response = response
      end
    end
  end
end
