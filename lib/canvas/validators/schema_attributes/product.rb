# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to product-type variables.
      class Product < Base
        ALLOWED_DEFAULT_VALUES = %w[random].freeze
        ALLOWED_RESTRICTIONS = %w[experiences accommodations extras].freeze

        def validate
          super &&
            ensure_default_values_are_valid &&
            ensure_only_values_are_valid
        end

        private

        def permitted_values_for_default_key
          if attribute["array"]
            Array
          else
            String
          end
        end

        def optional_keys
          super.merge("only" => Array)
        end

        def ensure_default_values_are_valid
          return true unless attribute.key?("default")

          if attribute["array"]
            attribute["default"].all? { |value| default_value_is_valid?(value) }
          else
            default_value_is_valid?(attribute["default"])
          end
        end

        def ensure_only_values_are_valid
          return true unless attribute.key?("only")

          if attribute["only"].empty?
            @errors << %["only" cannot be empty]
            return false
          end

          unsupported_entries = attribute["only"] - ALLOWED_RESTRICTIONS
          if unsupported_entries.any?
            @errors << %["only" for product-type variables must be one of: #{ALLOWED_RESTRICTIONS.join(', ')}]
            return false
          end

          true
        end

        def default_value_is_valid?(value)
          value = value.downcase
          if !ALLOWED_DEFAULT_VALUES.include?(value)
            @errors << %["default" for product-type variables must be one of: #{ALLOWED_DEFAULT_VALUES.join(', ')}]
            false
          else
            true
          end
        end
      end
    end
  end
end
