# frozen_string_literal: true

module DeepL
  module Resources
    class Glossary < Base
      attr_reader :id, :name

      def initialize(id, name, *args)
        super(*args)

        @id = id
        @name = name
      end

      def to_s
        "#{name}=>#{id}"
      end
    end
  end
end
