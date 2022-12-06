require "listen"
require "observer"

module Canvas
  class DevServer
    class Watcher
      include Observable

      def initialize
        @listener = Listen.to(Dir.getwd) do |modified, added, removed|
          changed
          notify_observers(modified, added, removed)
        end
      end

      def start
        @listener.start
      end

      def stop
        @listener.stop
      end
    end
  end
end
