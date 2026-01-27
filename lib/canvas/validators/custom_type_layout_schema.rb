# frozen_string_literal: true

require "json"
require "json-schema"

module Canvas
  module Validator
    # :documented:
    # This class is used to validate a layout definition for a custom type.
    # Custom type layouts use a flat array of elements (unlike block layouts which use tabs).
    #
    # Example of a valid custom type layout definition:
    # {
    #   "attributes" => [
    #     { "name" => "question", "type" => "string" },
    #     { "name" => "answer", "type" => "text" },
    #     { "name" => "show_icon", "type" => "boolean" }
    #   ],
    #   "layout" => [
    #     "question",
    #     {
    #       "type" => "accordion",
    #       "label" => "Advanced",
    #       "elements" => [
    #         "answer",
    #         { "type" => "attribute", "name" => "show_icon" }
    #       ]
    #     }
    #   ]
    # }
    class CustomTypeLayoutSchema
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
          ensure_accordion_toggles_are_valid
        end

        @errors.empty?
      end

      private

      attr_reader :schema

      def ensure_no_duplicate_keys
        attributes = fetch_all_attribute_names
        duplicates =
          attributes
            .group_by { |(key)| key }
            .filter { |_key, usage| usage.size > 1 }

        return if duplicates.empty?

        duplicates.each do |attribute, usage|
          @errors << "Duplicated attribute key `#{attribute}` found. "\
                     "Location: #{usage.map { |(_, location)| location }.join(', ')}"
        end
      end

      def ensure_no_unrecognized_keys
        attributes = fetch_all_attribute_names
        defined_attributes = schema_attributes.map { |attr| normalize_attribute(attr["name"]) }

        attributes.each do |attribute, location|
          unless defined_attributes.include?(attribute)
            @errors << "Unrecognized attribute `#{attribute}`. Location: #{location}"
          end
        end
      end

      # @return [Array<Array(String, String)>] an array of all the attribute names that
      #         are mentioned in the layout schema, along with its path. The names are
      #         normalized, i.e. downcased.
      def fetch_all_attribute_names
        attributes = fetch_elements_of_type("attribute")
        attributes.map do |(node, path)|
          [
            normalize_attribute(node.is_a?(Hash) ? node["name"] : node),
            path
          ]
        end
      end

      # @param type [String] the element type to fetch
      # @return [Array<Array(<Hash, String>, String)] an array of elements that match
      #   the given type. Each element is an array containing the node and its path.
      def fetch_elements_of_type(type)
        elements = []

        fetch_element = lambda { |node, path|
          if type == "attribute" && node.is_a?(String)
            elements << [node, path]
          elsif node.is_a?(Hash) && node["type"] == type
            elements << [node, path]
          end

          if node.is_a?(Hash) && node.key?("elements")
            node["elements"].each_with_index do |element, i|
              current_path = "#{path}/elements/#{i}"
              fetch_element.call(element, current_path)
            end
          end
        }

        # Flat layout: iterate directly over layout elements
        layout_schema.each_with_index do |element, i|
          current_path = "layout/#{i}"
          fetch_element.call(element, current_path)
        end

        elements
      end

      def ensure_valid_format
        result = JSON::Validator.fully_validate(
          schema_definition,
          { "layout" => layout_schema },
          strict: true,
          clear_cache: true
        )

        return true if result.empty?

        @errors += result
        false
      end

      def ensure_accordion_toggles_are_valid
        accordion_toggles = fetch_elements_of_type("accordion_toggle")
        accordion_toggles.each do |accordion_toggle, location|
          toggle_attribute = schema_attributes.detect { |attr|
            attr["name"] == accordion_toggle["toggle_attribute"]
          }

          if toggle_attribute.nil?
            @errors << "The toggle_attribute in accordion_toggle is unrecognized. Location: #{location}"
          elsif toggle_attribute["type"]&.downcase != "boolean"
            @errors << "The toggle_attribute in accordion_toggle must be a boolean. Location: #{location}"
          end
        end
      end

      def layout_schema
        schema["layout"] || []
      end

      def schema_definition
        File.read(
          File.join(File.dirname(__FILE__), "../../../", "schema_definitions", "custom_type_layout.json")
        )
      end

      def normalize_attribute(name)
        name.to_s.strip.downcase
      end

      def schema_attributes
        schema["attributes"] || []
      end
    end
  end
end
