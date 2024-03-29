# frozen_string_literal: true

module Canvas
  # :documented:
  class Checks
    class << self
      def registered
        @checks ||= []
      end

      def register(klass)
        @checks ||= []
        return if @checks.include?(klass)
        @checks << klass
      end

      def deregister_all!
        @checks = []
      end
    end
  end
end
