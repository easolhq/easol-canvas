# frozen_string_literal: true

module Canvas
  class Offense
    attr_reader :message

    def initialize(message:)
      @message = message
    end
  end
end
