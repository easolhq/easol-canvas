require_relative "../client"

module Canvas
  class DevServer
    class Syncer
      class << self
        def sync_file(path, subdomain, site_id)
          return if path.nil?
          relative_path = Pathname.new(path).relative_path_from(Dir.getwd)
          CLI::UI::Spinner.spin("Syncing #{relative_path}") {
            error_checks = Canvas::Lint.new.run([relative_path.to_s], nil)

            raise "Failed Linting #{relative_path}" if error_checks&.any?

            Canvas::Client.new.post(
              "/test_site_sync",
              subdomain:,
              body: {
                file_path: relative_path.to_s,
                file_content: File.read(path),
                site_id:
              }
            )
          }
        end
      end
    end
  end
end
