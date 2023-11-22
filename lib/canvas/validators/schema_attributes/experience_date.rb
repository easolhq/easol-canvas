# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to the experience_date variables.
      class ExperienceDate < Base
        ALLOWED_DEFAULT_VALUES = %w[next_upcoming].freeze

        def validate
          super && ensure_default_values_are_valid
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
            attribute["default"].all? { |value| default_value_is_valid?(value) }
          else
            default_value_is_valid?(attribute["default"])
          end
        end

        def default_value_is_valid?(value)
          value = value.downcase
          if !ALLOWED_DEFAULT_VALUES.include?(value)
            @errors << %["default" for experience_date variables must be one of: #{ALLOWED_DEFAULT_VALUES.join(', ')}]
            false
          else
            true
          end
        end
      end
    end
  end
end
