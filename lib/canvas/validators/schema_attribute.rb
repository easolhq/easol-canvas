# frozen_string_literal: true

require "nokogiri"
require "liquid"

module Canvas
  module Validator
    # :documented:
    # This class can be used to validate the format of an attribute that is used
    # within a schema.
    #
    # Example:
    # {
    #   "name" => "headings",
    #   "type" => "string",
    #   "default" => "My Heading",
    #   "array" => true
    # }
    #
    class SchemaAttribute
      VALIDATORS = {
        "image" => SchemaAttribute::Image,
        "product" => SchemaAttribute::Product,
        "post" => SchemaAttribute::Post,
        "page" => SchemaAttribute::Page,
        "link" => SchemaAttribute::Link,
        "text" => SchemaAttribute::Base,
        "string" => SchemaAttribute::Base,
        "boolean" => SchemaAttribute::Base,
        "number" => SchemaAttribute::Number,
        "color" => SchemaAttribute::Color,
        "select" => SchemaAttribute::Select,
        "range" => SchemaAttribute::Range,
        "radio" => SchemaAttribute::Radio,
        "variant" => SchemaAttribute::Variant,
        "package" => SchemaAttribute::Package,
      }.freeze
      RESERVED_NAMES = %w[
        page
        company
        cart
        flash
        block
      ].freeze

      attr_reader :attribute, :custom_types, :errors, :additional_reserved_names

      def initialize(attribute:, custom_types: [], additional_reserved_names: [])
        @attribute = attribute
        @custom_types = custom_types
        @errors = []
        @additional_reserved_names = additional_reserved_names
      end

      def validate
        ensure_attribute_is_hash &&
          ensure_not_reserved_name &&
          ensure_not_boolean_array &&
          ensure_not_radio_array &&
          ensure_type_key_is_present &&
          ensure_valid_for_type &&
          ensure_composite_array_without_non_array_attributes

        errors.empty?
      end

      private

      def attribute_type
        attribute["type"]&.downcase
      end

      def valid_types
        Constants::PRIMITIVE_TYPES + custom_type_keys
      end

      def validator_for_type
        @_validator ||= VALIDATORS[attribute_type].new(attribute) if VALIDATORS[attribute_type]
      end

      def custom_type_keys
        custom_types.map { |type| type["key"]&.downcase }.compact
      end

      def ensure_type_key_is_present
        return true if attribute.key?("type")

        @errors << "Missing required keys: type"
        false
      end

      def ensure_valid_for_type
        return true if custom_type_keys.include?(attribute_type)

        if validator_for_type.nil?
          @errors << "\"type\" must be one of: #{valid_types.join(', ')}"
          false
        else
          validator_for_type.validate
          errors.concat(validator_for_type.errors)
          validator_for_type.errors.empty?
        end
      end

      def ensure_attribute_is_hash
        return true if attribute.is_a? Hash

        @errors << "Must be valid JSON"
        false
      end

      def ensure_not_reserved_name
        all_reserved_names = RESERVED_NAMES + additional_reserved_names
        return true unless all_reserved_names.include?(attribute["name"])

        @errors << "\"name\" can't be one of these reserved words: #{all_reserved_names.join(', ')}"
        false
      end

      def ensure_not_boolean_array
        return true unless attribute["type"] == "boolean" && attribute["array"] == true

        @errors << "Boolean attributes cannot be arrays"
        false
      end

      def ensure_not_radio_array
        return true unless attribute["type"] == "radio" && attribute["array"] == true

        @errors << "Radio attributes cannot be arrays"
        false
      end

      def ensure_composite_array_without_non_array_attributes
        custom_type = custom_types.find { |type| type["key"]&.downcase == attribute_type }

        return true if !custom_type || attribute["array"] != true

        sub_attributes = custom_type.fetch("attributes", [])
        return true unless sub_attributes.any? { |attribute| attribute["type"] == "radio" }

        @errors << "Cannot be an array because \"#{custom_type['key']}\" type includes nonarray types"
        false
      end
    end
  end
end
