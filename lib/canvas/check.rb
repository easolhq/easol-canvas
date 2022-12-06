# frozen_string_literal: true

require "cli/ui"

module Canvas
  # :documented:
  class Check
    attr_reader :offenses

    def initialize
      @offenses = []
    end

    def run(scoped_files)
      raise NotImplementedError
    end

    def failed?
      @offenses.any?
    end
  end
end
