require "nokogiri"
require "liquid"

module Canvas
  module Validator
    class Html 
      LIQUID_TAG = /#{Liquid::TagStart}.*?#{Liquid::TagEnd}/om
      LIQUID_VARIABLE = /#{Liquid::VariableStart}.*?#{Liquid::VariableEnd}/om
      LIQUID_TAG_OR_VARIABLE = /#{LIQUID_TAG}|#{LIQUID_VARIABLE}/om

      attr_reader :errors
      def initialize(file)
        @file = file
      end

      def validate
        doc = Nokogiri::HTML5.fragment(file_stripped_of_liquid, max_errors: 1)
        @errors = doc.errors
        doc.errors.empty?
      end

      private
      
      def file_stripped_of_liquid
        @file.gsub(LIQUID_TAG_OR_VARIABLE, '')
      end
    end
  end
end
