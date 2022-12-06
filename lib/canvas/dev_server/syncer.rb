require_relative "../client"

module Canvas
  class DevServer
    class Syncer
      class << self
        def sync_file(path)
          return if path.nil?
          relative_path = Pathname.new(path).relative_path_from(Dir.getwd)
          CLI::UI::Spinner.spin("Syncing #{relative_path}") {
            Canvas::Client.new.post(
              "/test_site_sync",
              body: {
                path: path,
                contents: File.read(path)
              }
            )
          }
        end
      end
    end
  end
end
