module DeepL
  module Requests
    class Usage < Base
      def initialize(api, options = {})
        super(api, options)
      end

      def request
        build_usage(*get)
      end

      private

      def build_usage(request, response)
        data = JSON.parse(response.body)
        Resources::Usage.new(data['character_count'], data['character_limit'], request, response)
      end

      def path
        'usage'
      end
    end
  end
end
