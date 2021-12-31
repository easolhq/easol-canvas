require "nokogiri"

module Canvas
  module Validator
    class Html 
      attr_reader :errors
      def initialize(file)
        @file = file
      end

      def validate
        doc = Nokogiri::HTML(@file)
        @errors = doc.errors
        doc.errors.empty?
      end
    end
  end
end
