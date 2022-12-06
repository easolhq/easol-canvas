# frozen_string_literal: true

module Canvas
  # :documented:
  class ValidHtmlCheck < Check
    def run(scoped_files)
      html_files(scoped_files).each do |filename|
        file = File.read(filename)
        validator = Validator::Html.new(file)

        next if validator.validate

        validator.errors.map(&:message).each do |message|
          @offenses << Offense.new(
            message: "Invalid HTML: #{filename} - \n#{message}"
          )
        end
      end
    end

    def html_files(scoped_files)
      all_files = Dir.glob("**/*.{html,liquid}")
      if scoped_files.any?
        all_files & scoped_files
      else
        all_files
      end
    end
  end
end
