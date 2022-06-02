# frozen_string_literal: true

require "sassc"

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
        SassC::Engine.new(@file, style: :compressed).render
        true
      rescue SassC::SyntaxError => e
        @errors = [e.message]
        false
      end
    end
  end
end
