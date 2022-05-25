# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to color-type variables.
      class Color < Base
        def validate
          super &&
            ensure_default_keys_are_valid &&
            ensure_default_values_are_valid
        end

        private

        def permitted_values_for_default_key
          Hash
        end

        def ensure_default_keys_are_valid
          return true unless attribute.key?("default")
          return true if attribute["default"].key?("palette")

          key_diff = %w[r g b] - attribute["default"].keys
          if key_diff.any? && key_diff != ["a"]
            @errors << "\"default\" for color-type variables must include palette or rgba values"
            return false
          end

          true
        end

        def ensure_default_values_are_valid
          return true unless attribute.key?("default")

          if attribute["default"].key?("palette")
            ensure_palette_value_is_valid
          else
            ensure_rgb_value_is_valid
          end
        end

        def ensure_palette_value_is_valid
          return true if Constants::COLOR_PALETTE_VALUES.include?(attribute["default"]["palette"])

          @errors << "\"default\" value for palette color-type must be one of "\
                     "the following values: #{Constants::COLOR_PALETTE_VALUES.join(', ')}"
          false
        end

        def ensure_rgb_value_is_valid
          invalid_rgb_error = "\"default\" values for color-type variables must be "\
                              "between 0 and 255 for rgb, and between 0 and 1 for a"

          attribute["default"].each do |key, value|
            if %w[r g b].include?(key) && !valid_rgb_value?(value)
              @errors << invalid_rgb_error
              return false
            end

            if key == "a" && !valid_alpha_value?(value)
              @errors << invalid_rgb_error
              return false
            end
          end

          true
        end

        def valid_rgb_value?(value)
          value.to_s.match?(/\A\d+\z/) && value.to_i.between?(0, 255)
        end

        def valid_alpha_value?(value)
          value.to_s.match?(/([0-9]*[.])?[0-9]+/) && value.to_f.between?(0, 1)
        end
      end
    end
  end
end
