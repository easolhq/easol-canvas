require_relative "dev_server/watcher"
require_relative "dev_server/syncer"
require_relative "local_config"

module Canvas
  class DevServer
    def initialize
      @watcher = Watcher.new
      @subdomain = Canvas::LocalConfig.get(:attached_company_subdomain)
      @site_id = Canvas::LocalConfig.get(:site_id)
    end

    def run
      check_api_key_present
      CLI::UI::StdoutRouter.enable
      @watcher.add_observer(self, :sync_files)

      CLI::UI::Frame.open("Running Dev Server") do
        create_dev_site or raise

        `open https://#{@subdomain}.easol.test/admin/site_builder/sites/#{@site_id}/pages`
        start_watcher

        puts "Finishing"
        stop_watcher
      end
    end

    def sync_files(modified, added, removed)
      Canvas::DevServer::Syncer.sync_file(modified[0], @subdomain, @site_id)
      Canvas::DevServer::Syncer.sync_file(added[0], @subdomain, @site_id)
      Canvas::DevServer::Syncer.sync_file(removed[0], @subdomain, @site_id)
    end

    private

    def start_watcher
      @watcher.start

      sleep
    rescue Interrupt
    end

    def stop_watcher
      @watcher.stop
    end

    def create_dev_site
      CLI::UI::Spinner.spin("Generating temporary dev site") {
        response = Canvas::Client.new.post("/canvas_api/dev_sites", subdomain: @subdomain)
        status = "pending"

        until status != "pending"
          job_response = Canvas::Client.new.get(
            "/canvas_api/dev_sites?site_duplication_job_id=#{response["site_duplication_job_id"]}",
            subdomain: @subdomain
          )
          status = job_response["status"]
          sleep(1)
        end

        if job_response["site_id"]
          Canvas::LocalConfig.set(site_id: job_response["site_id"])
        else
          raise "Failed to create dev site."
        end
      }
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
