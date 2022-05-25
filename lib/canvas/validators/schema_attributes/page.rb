# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to page-type variables.
      class Page < Base
        ALLOWED_DEFAULT_VALUES = %w[ random ].freeze

        def validate
          super &&
            ensure_default_values_are_valid
        end

        private

        def permitted_values_for_default_key
          if attribute["array"]
            Array
          else
            String
          end
        end

        def ensure_default_values_are_valid
          return true unless attribute.key?("default")

          if attribute["array"]
            attribute["default"].all? { |value| default_value_is_validate(value) }
          else
            default_value_is_validate(attribute["default"])
          end
        end

        def default_value_is_validate(value)
          value = value.downcase
          if !ALLOWED_DEFAULT_VALUES.include?(value)
            @errors << "\"default\" for page-type variables must be "\
                       "one of: #{ALLOWED_DEFAULT_VALUES.join(', ')}"
            false
          else
            true
          end
        end
      end
    end
  end
end
