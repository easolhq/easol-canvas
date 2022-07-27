# frozen_string_literal: true

require "json"
require "json-schema"

module Canvas
  module Validator
    # :documented:
    # This class is used to validate a layout definition, part of block schema.
    # Example of a valid layout definition:
    # {
    #   "attributes" => [
    #     {
    #       "name" => "title",
    #       "type" => "string"
    #     }
    #     ...
    #   ],
    #   "layout" => [
    #     {
    #       "label" => "Design",
    #       "type" => "tab",
    #         "elements" => [
    #         "heading",
    #         {
    #           "type" => "accordion",
    #           "label" => "Logo",
    #           "elements" => [
    #             "description",
    #             { "type" => "attribute", "name" => "logo_alt" },
    #             "title"
    #           ]
    #         },
    #         {
    #           "type" => "accordion_toggle",
    #           "toggle_attribute" => "cta_enabled",
    #           "elements" => [
    #             "cta_text",
    #             "cta_target"
    #           ]
    #         }
    #       ]
    #     }
    #   ]
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
          .filter { |key, usage| usage.size > 1 }

        unless duplicates.empty?
          duplicates.each do |attribute, usage|
            @errors << "Duplicated attribute key `#{attribute}` found. Location: #{usage.map { |(_, location)| location }.join(", ")}"
          end
        end
      end

      def ensure_no_unrecognized_keys
        attributes = fetch_all_attribute_names
        defined_attributes = schema["attributes"]&.map { |definition| normalize_attribute(definition["name"]) } || []

        attributes.each do |attribute, location|
          @errors << "Unrecognized attribute `#{attribute}`. Location: #{location}" unless defined_attributes.include?(attribute)
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

      def ensure_accordion_toggles_are_valid
        accordion_toggles = fetch_elements_of_type("accordion_toggle")
        accordion_toggles.each do |accordion_toggle, location|
          toggle_attribute = schema["attributes"]&.detect { |attr|
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
          File.join(File.dirname(__FILE__), "../../../", "schema_definitions", "layout.json")
        )
      end

      def normalize_attribute(name)
        name.strip.downcase
      end
    end
  end
end
