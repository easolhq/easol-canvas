require_relative "dev_server/watcher"
require_relative "dev_server/watchlist"

module Canvas
  class DevServer
    def initialize
      @watchlist = WatchList.new
      @watcher = Watcher.new(@watchlist)
    end

    def run
      @watcher.add_observer(self, :sync_files)

      puts "Listening for changes"
      start

      puts "Finishing"
      stop
    end

    def start
      @watcher.start

      sleep
    rescue Interrupt
    end

    def stop
      @watcher.stop
    end

    def sync_files(modified, added, removed)
      puts "CHANGED #{modified.first}"
    end
  end
end
