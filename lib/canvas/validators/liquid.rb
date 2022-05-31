# frozen_string_literal: true

require "nokogiri"
require "liquid"

module Canvas
  module Validator
    # :documented:
    class Liquid
      attr_reader :errors

      def initialize(file)
        @file = file
      end

      def validate
        liquid = strip_out_front_matter(@file)
        ::Liquid::Template.parse(
          liquid,
          line_numbers: true,
          error_mode: :warn
        )
        true
      rescue ::Liquid::SyntaxError => e
        @errors = [e.message]
        false
      end

      private

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
