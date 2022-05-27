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
        next unless Dir.glob(filename).empty?

        @offenses << Offense.new(
          message: "Missing file: #{filename}"
        )
      end
    end
  end
end
