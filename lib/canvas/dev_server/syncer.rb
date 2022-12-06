require_relative "../client"

module Canvas
  class DevServer
    class Syncer
      class << self
        def sync_file(path)
          return if path.nil?
          relative_path = Pathname.new(path).relative_path_from(Dir.getwd)
          CLI::UI::Spinner.spin("Syncing #{relative_path}") {
            error_checks = Canvas::Lint.new.run([relative_path.to_s], nil)

            raise "Failed Linting #{relative_path}" if error_checks&.any?

            Canvas::Client.new.post(
              "/test_site_sync",
              body: {
                file_path: path,
                file_contents: File.read(path)
              }
            )
          }
        end
      end
    end
  end
end
