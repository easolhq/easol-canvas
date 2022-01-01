module Canvas
  class RequiredFilesCheck < Check
    REQUIRED_FILES = [
      "templates/product/index.liquid",
      "templates/blog_overview/index.liquid",
      "templates/blog_post/index.liquid",
      "partials/footer/index.liquid",
      "partials/menu/index.liquid",
      "assets/index.css"
    ]

    def run
      REQUIRED_FILES.each do |filename|
        unless File.exists?(filename)
            @offenses << Offense.new(
              message: "Missing file: #{filename}"
            )
        end
      end
    end
  end
end
