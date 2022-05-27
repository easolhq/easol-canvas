# frozen_string_literal: true

require_relative "base"

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to range-type variables.
      class Range < Base
        private

        def optional_keys
          super.merge(
            "min" => Object,
            "max" => Object,
            "step" => Object,
            "unit" => String
          )
        end
      end
    end
  end
end
