require "nokogiri"

module Canvas
  module Validator
    class Html 
      attr_reader :errors
      def initialize(file)
        @file = file
      end

      def validate
        doc = Nokogiri::HTML5.fragment(@file, max_errors: 1)
        @errors = doc.errors
        doc.errors.empty?
      end
    end
  end
end
