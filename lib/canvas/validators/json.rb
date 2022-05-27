require "json"

module Canvas
  module Validator
    class Json
      attr_reader :errors

      def initialize(file)
        @file = file
      end

      def validate
        ::JSON.parse(@file)
        true
      rescue ::JSON::ParserError => e
        @errors = [e.message]
        false
      end
    end
  end
end
