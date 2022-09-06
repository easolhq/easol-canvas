# frozen_string_literal: true

require "canvas/dartsass"

module Canvas
  module Validator
    # :documented:
    #
    # This validator can be used to validate Sass.
    class Sass
      attr_reader :errors

      def initialize(file)
        @file = file
      end

      def validate
        DartSass.new(@file, style: :compressed).render
        true
      rescue DartSass::Error => e
        @errors = [e.message]
        false
      end
    end
  end
end
