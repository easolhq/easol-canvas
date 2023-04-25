# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      #
      # Validations to run against an attribute's schema that are shared
      # across types. This class acts as the base class for type-specific
      # validators.
      class Base
        attr_reader :attribute, :errors

        def initialize(attribute)
          @attribute = attribute
          @errors = []
        end

        def validate
          ensure_has_required_keys &&
            ensure_no_unrecognized_keys &&
            ensure_keys_are_correct_types
        end

        private

        # The base keys required for this attribute to be valid and their
        # expected types. Types can also be specified as an array of discrete
        # expected values.
        # This can be overwritten in sub-validator class.
        #
        # @return [Hash]
        def required_keys
          {
            "name" => String,
            "type" => String
          }
        end

        # Either a class or array of values we expect the default to be.
        # This can be overwritten in sub-validator class.
        def permitted_values_for_default_key
          Object
        end

        # The optional keys that can be supplied for this attribute and their
        # expected types. Types can also be specified as an array of discrete
        # expected values.
        # This can be overwritten in sub-validator class.
        #
        # @return [Hash]
        def optional_keys
          {
            "default" => permitted_values_for_default_key,
            "array" => [true, false],
            "max_item_levels" => [1, 2, 3],
            "label" => String,
            "hint" => String,
            "group" => %w[content layout design mobile]
          }
        end

        def all_permitted_keys
          required_keys.merge(optional_keys)
        end

        def ensure_has_required_keys
          missing_keys = required_keys.keys - attribute.keys
          return true if missing_keys.empty?

          @errors << "Missing required keys: #{missing_keys.join(', ')}"
          false
        end

        def ensure_no_unrecognized_keys
          unrecognized_keys = attribute.keys - all_permitted_keys.keys
          return true if unrecognized_keys.empty?

          @errors << "Unrecognized keys: #{unrecognized_keys.join(', ')}"
          false
        end

        def ensure_keys_are_correct_types
          all_permitted_keys.each do |key, expected|
            if expected.is_a?(Class)
              if attribute.key?(key) && !attribute[key].is_a?(expected)
                actual = attribute[key].class.name
                @errors << "\"#{key}\" is a #{actual}, expected #{expected}"
                return false
              end
            else
              if attribute.key?(key) && !expected.include?(attribute[key])
                actual = attribute[key].to_s
                @errors << "\"#{key}\" is '#{actual}', expected one of: #{[*expected].join(', ')}"
                return false
              end
            end
          end

          true
        end
      end
    end
  end
end
