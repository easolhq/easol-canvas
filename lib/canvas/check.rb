require 'cli/ui'

module Canvas
  class Check
    attr_reader :offenses

    def initialize
      @offenses = []
    end

    def run
      raise NotImplementedError
    end

    def failed?
      @offenses.any?
    end
  end
end
