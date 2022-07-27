# frozen_string_literal: true

module Canvas
  module Validator
    # :documented:
    # This class is used to validate a schema for a menu.
    #
    # Example:
    # {
    #   "max_item_levels": 2,
    #   "supports_open_new_tab": "true",
    #   "attributes": {
    #      "fixed": {
    #         "group": "design",
    #         "label": "Fixed when scrolling",
    #         "hint": "The menu will stay fixed to the top when scrolling down the page.",
    #         "type": "boolean",
    #         "default: "false"
    #      }
    #   }
    # }
    #
    class MenuSchema
      PERMITTED_KEYS = %w[max_item_levels supports_open_new_tab attributes layout].freeze
      ADDITIONAL_RESERVED_NAMES = %w[items type].freeze

      attr_reader :schema, :errors

      # @param schema [Hash] the schema to be validated
      # @param custom_types [Array<Hash>] a list of custom types
      def initialize(schema:, custom_types: [])
        @schema = schema
        @custom_types = custom_types
        @errors = []
      end

      def validate
        if ensure_valid_format
          ensure_no_unrecognized_keys
          ensure_max_item_levels_is_valid
          ensure_layout_is_valid
          ensure_attributes_are_valid
        end

        @errors.empty?
      end

      private

      def ensure_valid_format
        return true if schema.is_a?(Hash) &&
                       (schema["attributes"].nil? || attributes_array_of_hashes?(schema))

        @errors << "Schema is not in a valid format"
        false
      end

      def ensure_no_unrecognized_keys
        unrecognized_keys = schema.keys - PERMITTED_KEYS
        return true if unrecognized_keys.empty?

        @errors << "Unrecognized keys: #{unrecognized_keys.join(', ')}"
        false
      end

      def ensure_max_item_levels_is_valid
        return true unless schema.key?("max_item_levels")
        return true if [1, 2, 3].include?(schema["max_item_levels"].to_i)

        @errors << "\"max_item_levels\" must be a number between 1 and 3"
        false
      end

      def ensure_layout_is_valid
        return true unless schema["layout"]

        layout_validator = LayoutSchema.new(schema: @schema)
        return true if layout_validator.validate

        @errors += layout_validator.errors
        false
      end

      def ensure_attributes_are_valid
        return true unless schema["attributes"]

        schema["attributes"].each do |attribute_schema|
          attr_validator = Validator::SchemaAttribute.new(
            attribute: attribute_schema,
            custom_types: @custom_types,
            additional_reserved_names: ADDITIONAL_RESERVED_NAMES
          )
          next if attr_validator.validate

          @errors << "Attribute \"#{attribute_schema['name']}\" is invalid "\
                     "- #{attr_validator.errors.join(', ')}"
        end
      end

      def attributes_array_of_hashes?(schema)
        schema["attributes"].is_a?(Array) &&
          schema["attributes"].all? { |attr| attr.is_a?(Hash) }
      end
    end
  end
end
