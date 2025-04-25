# frozen_string_literal: true

require "nokogiri"
require "liquid"

module Canvas
  module Validator
    # :documented:
    class Html
      LIQUID_TAG = /#{::Liquid::TagStart}.*?#{::Liquid::TagEnd}/om
      LIQUID_VARIABLE = /#{::Liquid::VariableStart}.*?#{::Liquid::VariableEnd}/om
      LIQUID_TAG_OR_VARIABLE = /#{LIQUID_TAG}|#{LIQUID_VARIABLE}/om

      attr_reader :errors

      def initialize(file)
        @file = file
      end

      def validate
        doc = Nokogiri::HTML5.fragment(extracted_html, max_errors: 1)
        @errors = doc.errors
        doc.errors.empty?
      end

      private

      def extracted_html
        html = strip_out_front_matter(@file)
        strip_out_liquid(html)
      end

      # We want to strip out the liquid tags and replace them with the
      # same number of characters, so that the linter reports the
      # correct character number.
      def strip_out_liquid(html)
        html.gsub(LIQUID_TAG_OR_VARIABLE) { |tag| "x" * tag.size }
      end

      # We want to strip out the front matter and replace it
      # with empty new lines, so that linter output reports the
      # correct line numbers
      def strip_out_front_matter(html)
        extractor = Canvas::FrontMatterExtractor.new(html)

        if extractor.front_matter
          num_lines = extractor.front_matter.lines.size - 1
          html.sub(extractor.front_matter, "\n" * num_lines)
        else
          html
        end
      end
    end
  end
end
