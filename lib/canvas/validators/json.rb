# frozen_string_literal: true

require "json"

module Canvas
  module Validator
    # :documented:
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
