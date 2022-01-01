module Canvas
  class ValidHtmlCheck < Check
    def run
      html_files.each do |filename|
        file = File.read(filename)

        validator = Validator::Html.new(file)

        unless validator.validate
          validator.errors.map(&:message).each do |message|
            @offenses << Offense.new(
              message: "Invalid HTML: #{filename} - \n#{message}",
            )
          end
        end
      end
    end

    def html_files
      Dir.glob("**/*.liquid") + Dir.glob("**/*.html")
    end
  end
end
