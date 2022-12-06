require_relative "dev_server/watcher"
require_relative "dev_server/syncer"

module Canvas
  class DevServer
    def initialize
      @watcher = Watcher.new
    end

    def run
      check_api_key_present
      CLI::UI::StdoutRouter.enable
      @watcher.add_observer(self, :sync_files)


      CLI::UI::Frame.open("Running Dev Server") do
        start

        puts "Finishing"
        stop
      end
    end

    def sync_files(modified, added, removed)
      Canvas::DevServer::Syncer.sync_file(modified[0])
      Canvas::DevServer::Syncer.sync_file(added[0])
      Canvas::DevServer::Syncer.sync_file(removed[0])
    end
    
    private

    def start
      @watcher.start

      sleep
    rescue Interrupt
    end

    def stop
      @watcher.stop
    end

    def check_api_key_present
      api_key = Canvas::GlobalConfig.get(:api_key)
      unless api_key
        puts "No api key set, please use canvas login to set your api key"
        exit 1
      end
    end
  end
end
