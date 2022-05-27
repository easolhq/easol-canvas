# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to link-type variables.
      class Image < Base
        ALLOWED_DEFAULT_KEYS = %w[url asset].freeze

        def validate
          super && ensure_default_key_is_valid
        end

        private

        def ensure_default_key_is_valid
          return true unless attribute.key?("default")

          if attribute["array"]
            attribute["default"].all? { |value| default_value_is_validate(value) }
          else
            default_value_is_validate(attribute["default"])
          end
        end

        # The default value can be one of 3 different formats:
        # - A string (for backwards compatibility) e.g. "http://my-image.jpg"
        # - A hash with "url" key" e.g. { "url": "http://my-image.jpg" }
        # - A hash with "asset" key" e.g. { "asset": "http://my-image.jpg" }
        def default_value_is_validate(value)
          return true if value.is_a?(String)

          return true if value.is_a?(Hash) &&
                         value.keys.size == 1 &&
                         ALLOWED_DEFAULT_KEYS.include?(value.keys.first) &&
                         value.values.first.is_a?(String)

          @errors << "\"default\" for image-type variables must include a single url or asset value"
          false
        end
      end
    end
  end
end
