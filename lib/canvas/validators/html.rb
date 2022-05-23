require "nokogiri"
require "liquid"

module Canvas
  module Validator
    class Html
      LIQUID_TAG = /#{Liquid::TagStart}.*?#{Liquid::TagEnd}/om
      LIQUID_VARIABLE = /#{Liquid::VariableStart}.*?#{Liquid::VariableEnd}/om
      LIQUID_TAG_OR_VARIABLE = /#{LIQUID_TAG}|#{LIQUID_VARIABLE}/om
      HTML_LIQUID_PLACEHOLDER = /≬[0-9a-z\n]+[#\n]*≬/m

      attr_reader :errors

      def initialize(file)
        @file = file
        @placeholders = []
      end

      def validate
        doc = Nokogiri::HTML5.fragment(extracted_html, max_errors: 1)
        @errors = resub_placeholders(doc.errors)
        doc.errors.empty?
      end

      private

      def extracted_html
        html = strip_out_front_matter(@file)
        strip_out_liquid(html)
      end

      # We want to strip out the liquid tags and replace them with the
      # same number of empty space characters, so that the linter
      # reports the correct character number.
      def strip_out_liquid(html)
        html.gsub(LIQUID_TAG_OR_VARIABLE) { |tag|
          next unless tag.size > 4

          placeholder_index = @placeholders.size.to_s(36)
          @placeholders << tag
          placeholder_length = tag.size - placeholder_index.size - 2
          "≬#{placeholder_index}#{"#" * placeholder_length}≬"
        }
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

      def resub_placeholders(errors)
        errors.map do |error|
          error.message.gsub(HTML_LIQUID_PLACEHOLDER) do |match|
            key = /[0-9a-z]+/.match(match.gsub("\n", ''))[0]
            @placeholders[key.to_i(36)]
          end
        end
      end
    end
  end
end
