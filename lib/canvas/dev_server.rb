require_relative "dev_server/watcher"

module Canvas
  class DevServer
    def initialize
      @watcher = Watcher.new
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
      puts "Modified #{modified}"
      puts "Added #{added}"
      puts "Removed #{removed}"
    end
  end
end
