# frozen_string_literal: true

module DeepL
  module Requests
    class Base
      attr_reader :api, :response, :options

      def initialize(api, options = {})
        @api = api
        @options = options
      end

      def request
        raise NotImplementedError
      end

      private

      def option?(name)
        options.key?(name.to_s) || options.key?(name.to_sym)
      end

      def option(name)
        options[name.to_s] || options[name.to_sym]
      end

      def delete_option(name)
        options.delete(name.to_s) || options.delete(name.to_sym)
      end

      def set_option(name, value)
        if options.key?(name.to_sym)
          options[name.to_sym] = value
        else
          options[name.to_s] = value
        end
      end

      def post(payload)
        request = Net::HTTP::Post.new(uri.request_uri, headers)
        request.set_form_data(payload.compact)
        response = http.request(request)

        validate_response!(request, response)
        [request, response]
      end

      def get
        request = Net::HTTP::Get.new(uri.request_uri, headers)
        response = http.request(request)

        validate_response!(request, response)
        [request, response]
      end

      def delete
        request = Net::HTTP::Delete.new(uri.request_uri, headers)
        response = http.request(request)

        validate_response!(request, response)
        [request, response]
      end

      def http
        @http ||= begin
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          http
        end
      end

      def validate_response!(request, response)
        return if response.is_a?(Net::HTTPSuccess)

        raise Utils::ExceptionBuilder.new(request, response).build
      end

      def path
        raise NotImplementedError
      end

      def url
        "#{host}/#{api.configuration.version}/#{path}"
      end

      def uri
        @uri ||= begin
          uri = URI(url)
          new_query = URI.decode_www_form(uri.query || '') + query_params.to_a
          uri.query = URI.encode_www_form(new_query)
          uri
        end
      end

      def host
        api.configuration.host
      end

      def query_params
        options
      end

      def headers
        { 'Authorization' => "DeepL-Auth-Key #{api.configuration.auth_key}" }
      end
    end
  end
end
