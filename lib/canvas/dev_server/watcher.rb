require "listen"
require "observer"

module Canvas
  class DevServer
    class Watcher
      include Observable

      def initialize(watchlist)
        return unless watchlist.files.any?

        files = watchlist.files.join("$|").gsub!(".", "\.") + "$"

        @listener = Listen.to(Dir.getwd, only: /#{files}/) do |modified, added, removed|
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
