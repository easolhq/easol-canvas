# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to link-type variables.
      class Link < Base
        ALLOWED_DEFAULT_KEYS = %w[url page post experience accommodation].freeze
        INVALID_DEFAULT_ERROR = "\"default\" for link-type variables must include "\
                                "a single url, page, post, experience or accommodation value"

        def validate
          super &&
            ensure_single_default_provided &&
            ensure_default_key_is_valid
        end

        private

        def permitted_values_for_default_key
          Hash
        end

        def ensure_default_key_is_valid
          return true unless attribute.key?("default")

          key = attribute["default"].keys.first

          unless ALLOWED_DEFAULT_KEYS.include?(key)
            @errors << INVALID_DEFAULT_ERROR
            return false
          end

          true
        end

        def ensure_single_default_provided
          return true unless attribute.key?("default")

          if attribute["default"].count != 1
            @errors << INVALID_DEFAULT_ERROR
            return false
          end

          true
        end
      end
    end
  end
end
