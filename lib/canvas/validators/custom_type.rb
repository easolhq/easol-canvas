# frozen_string_literal: true

module Canvas
  module Validator
    # :documented:
    # This class is used to validate the JSON defining a custom type.
    #
    # An example of a valid custom type:
    # {
    #   "key": "faq",
    #   "name": "Faq",
    #   "attributes": [
    #     {
    #       "name": "question",
    #       "label": "Question",
    #       "type": "string"
    #     },
    #     {
    #       "name": "answer",
    #       "label": "Answer",
    #       "type": "text"
    #     }
    #   ]
    # }
    #
    class CustomType
      REQUIRED_KEYS = %w[key name attributes].freeze

      attr_reader :schema, :errors

      def initialize(schema:)
        @schema = schema
        @errors = []
      end

      def validate
        ensure_valid_format &&
          ensure_has_required_keys &&
          ensure_no_unrecognized_keys &&
          ensure_keys_are_correct_types &&
          ensure_no_duplicate_attributes &&
          ensure_attributes_are_valid &&
          ensure_first_attribute_not_array

        errors.empty?
      end

      private

      def ensure_valid_format
        return true if schema.is_a?(Hash)

        @errors << "Schema is not in a valid format"
        false
      end

      def ensure_has_required_keys
        missing_keys = REQUIRED_KEYS - schema.keys
        return true if missing_keys.empty?

        @errors << "Missing required keys: #{missing_keys.join(', ')}"
        false
      end

      def ensure_no_unrecognized_keys
        unrecognized_keys = schema.keys - REQUIRED_KEYS
        return true if unrecognized_keys.empty?

        @errors << "Unrecognized keys: #{unrecognized_keys.join(', ')}"
        false
      end

      def ensure_keys_are_correct_types
        if !schema["key"].is_a?(String)
          @errors << "\"key\" must be a string"
          return false
        end

        if !schema["name"].is_a?(String)
          @errors << "\"name\" must be a string"
          return false
        end

        if !schema["attributes"].is_a?(Array) ||
            schema["attributes"].empty? ||
            schema["attributes"].any? { |a| !a.is_a?(Hash) }
            @errors << "\"attributes\" must be an array of objects"
          return false
        end

        true
      end

      def ensure_no_duplicate_attributes
        attribute_names = schema["attributes"].map { |a| a["name"] }
        duplicated_names = attribute_names.select { |a| attribute_names.count(a) > 1 }.uniq

        return true if duplicated_names.empty?

        @errors << "Some attributes are duplicated: #{duplicated_names.join(', ')}"
        false
      end

      def ensure_attributes_are_valid
        return true unless schema["attributes"]

        schema["attributes"].each do |attribute_schema|
          attr_validator = Validator::SchemaAttribute.new(
            attribute: attribute_schema,
            custom_types: []
          )
          next if attr_validator.validate

          @errors << "Attribute \"#{attribute_schema['name']}\" is invalid "\
                     "- #{attr_validator.errors.join(', ')}"
        end
      end

      def ensure_first_attribute_not_array
        first_attribute = schema.fetch("attributes").first

        return true if first_attribute.nil? || first_attribute["array"] != true

        @errors << "The first attribute cannot be an array"
        false
      end
    end
  end
end
