# frozen_string_literal: true

module Canvas
  module Validator
    class SchemaAttribute
      # :documented:
      # Attribute validations specific to number-type variables.
      class Number < Base
        private

        def optional_keys
          super.merge("unit" => String)
        end
      end
    end
  end
end
