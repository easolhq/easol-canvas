# frozen_string_literal: true

require "nokogiri"
require "liquid"

module Canvas
  module Validator
    # :documented:
    # This class is used to validate a schema for a block.
    # Example of a valid block schema:
    # {
    #   "attributes" => {
    #     "my_title" => {
    #       "type" => "string"
    #     },
    #     "my_color" => {
    #       "type" => "color",
    #       "label" => "My color",
    #       "hint" => "Select your favourite color"
    #     }
    #   },
    #   "layout" => [
    #     {
    #       "type" => "tab",
    #       "label" => "Content",
    #       "elements" => [
    #         "my_title",
    #         "my_color"
    #       ]
    #     }
    #   ]
    # }
    class BlockSchema
      PERMITTED_KEYS = %w[attributes layout].freeze

      attr_reader :errors, :schema

      # @param schema [Hash] the schema to be validated
      # @param custom_types [Array<Hash>] a list of custom types
      def initialize(schema:, custom_types: [])
        @schema = normalize_schema(schema)
        @custom_types = custom_types
        @errors = []
      end

      def validate
        @errors = []

        if ensure_valid_format
          ensure_no_unrecognized_keys
          ensure_layout_is_valid
          ensure_attributes_are_valid
        end

        @errors.empty?
      end

      private

      def ensure_valid_format
        return true if schema.is_a?(Hash) &&
                       (schema["attributes"].nil? || attributes_hash_of_hashes?(schema))

        @errors << "Schema is not in a valid format"
        false
      end

      def ensure_layout_is_valid
        return true unless schema["layout"]

        layout_validator = LayoutSchema.new(schema: @schema)
        return true if layout_validator.validate

        @errors += layout_validator.errors
        false
      end

      def ensure_no_unrecognized_keys
        unrecognized_keys = schema.keys - PERMITTED_KEYS
        return true if unrecognized_keys.empty?

        @errors << "Unrecognized keys: #{unrecognized_keys.join(', ')}"
        false
      end

      def ensure_attributes_are_valid
        return true unless schema["attributes"]

        attributes = Canvas::ExpandAttributes.call(schema["attributes"])
        attributes.each do |attribute_schema|
          attr_validator = Validator::SchemaAttribute.new(
            attribute: attribute_schema,
            custom_types: @custom_types
          )
          next if attr_validator.validate

          @errors << "Attribute \"#{attribute_schema['name']}\" is invalid "\
                     "- #{attr_validator.errors.join(', ')}"
        end
      end

      def attributes_hash_of_hashes?(schema)
        schema["attributes"].is_a?(Hash) &&
          schema["attributes"].values.all? { |attr| attr.is_a?(Hash) }
      end

      # To support older schemas that do not nest the attributes
      # under the `attributes` key.
      def normalize_schema(schema)
        return schema if schema.key?("attributes")

        { "attributes" => schema }
      end
    end
  end
end
