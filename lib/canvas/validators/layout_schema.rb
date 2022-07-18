# frozen_string_literal: true

require "json"
require "json-schema"

module Canvas
  module Validator
    # :documented:
    # This class is used to validate a layout definition, part of block schema.
    # Example of a valid layout definition:
    # {
    #   "layout" => [
    #   {
    #      "label" => "Design",
    #      "type" => "tab",
    #     "elements" => [
    #       "heading",
    #       {
    #         "type" => "accordion",
    #         "label" => "Logo",
    #         "elements" => [
    #           "description",
    #           { "type" => "attribute", "name" => "logo_alt" },
    #           "title"
    #         ]
    #       }
    #     ]
    #   }]
    # }
    class LayoutSchema
      attr_reader :errors

      def initialize(schema:)
        @schema = schema
        @errors = []
      end

      def validate
        @errors = []

        if ensure_valid_format
          ensure_no_unrecognized_keys
          ensure_no_duplicate_keys
        end

        @errors.empty?
      end

      private

      def ensure_no_duplicate_keys
        attributes = gather_attributes_from_layout_schema
        duplicates =
          attributes
          .group_by { |(key)| key }
          .filter { |key, usage| usage.size > 1 }

        unless duplicates.empty?
          duplicates.each do |attribute, usage|
            @errors << "Duplicated attribute key `#{attribute}` found. Location: #{usage.map { |(_, location)| location }.join(", ")}"
          end
        end
      end

      def ensure_no_unrecognized_keys
        attributes = gather_attributes_from_layout_schema
        defined_attributes = @schema["attributes"]&.map { |definition| normalize_attribute(definition["name"]) } || []

        attributes.each do |attribute, location|
          @errors << "Unrecognized attribute `#{attribute}`. Location: #{location}" unless defined_attributes.include?(attribute)
        end
      end

      def gather_attributes_from_layout_schema
        attributes = fetch_elements_of_type("attribute")
        attributes.map do |(node, path)|
          [
            normalize_attribute(node.is_a?(Hash) ? node["name"] : node),
            path
          ]
        end
      end

      # @param type [String] the element type to fetch
      # @return [Array<Hash, String>] a flat array of elements that match
      #   the given type
      def fetch_elements_of_type(type)
        elements = []

        fetch_element = ->(node, path) {
          if type == "attribute" && node.is_a?(String)
            elements << [node, path]
          elsif node["type"] == type
            elements << [node, path]
          end

          if node.is_a?(Hash) && node.key?("elements")
            node["elements"].each_with_index do |element, i|
              current_path = "#{path}/elements/#{i}"
              fetch_element.call(element, current_path)
            end
          end
        }

        layout_schema.each_with_index do |tab, i|
          current_path = "layout/#{i}"
          fetch_element.call(tab, current_path)
        end

        elements
      end

      def ensure_valid_format
        result = JSON::Validator.fully_validate(schema_definition, { "layout" => layout_schema }, strict: true, clear_cache: true)

        return true if result.empty?

        @errors += result
        false
      end

      def layout_schema
        @schema["layout"] || []
      end

      def schema_definition
        File.read(
          File.join(File.dirname(__FILE__), "../../../", "schema_definitions", "block_layout.json")
        )
      end

      def normalize_attribute(name)
        name.strip.downcase
      end
    end
  end
end
