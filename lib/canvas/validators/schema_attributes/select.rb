# frozen_string_literal: true

require_relative "base"

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to select-type variables.
      class Select < Base
        def validate
          super &&
            ensure_at_least_one_option &&
            ensure_options_are_valid
        end

        private

        def permitted_values_for_default_key
          if attribute["options"].is_a?(Array)
            attribute["options"].map { |option|
              option["value"] if option.is_a?(Hash)
            }
          else
            []
          end
        end

        def required_keys
          super.merge(
            "options" => Array
          )
        end

        def ensure_at_least_one_option
          return true if attribute["options"].length.positive?

          @errors << "Must provide at least 1 option for select type variable"
          false
        end

        def select_option_validate(option)
          option.is_a?(Hash) &&
            option.key?("value") &&
            option.key?("label")
        end

        def ensure_options_are_valid
          return true if attribute["options"].all? { |option|
            select_option_validate(option)
          }

          @errors << "All options for select type variable must specify a label and value"
          false
        end
      end
    end
  end
end
