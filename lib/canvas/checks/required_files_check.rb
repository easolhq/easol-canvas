# frozen_string_literal: true

module Canvas
  # :documented:
  class RequiredFilesCheck < Check
    REQUIRED_FILES = [
      "templates/product/index.{html,liquid}",
      "templates/blog_overview/index.{html,liquid}",
      "templates/blog_post/index.{html,liquid}",
      "partials/footer/index.{html,liquid}",
      "partials/menu/index.{html,liquid}",
      "assets/index.css"
    ].freeze

    def run
      REQUIRED_FILES.each do |filename|
        file_paths = Dir.glob(filename)


        if file_paths.empty?
          @offenses << Offense.new(
            message: "Missing file: #{filename}"
          )
        elsif File.zero?(file_paths.first)
          @offenses << Offense.new(
            message: "Empty file: #{file_paths.first}"
          )
        end
      end
    end
  end
end
