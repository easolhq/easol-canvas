# frozen_string_literal: true

module Canvas
  # :documented:
  #
  # This check will find all files ending in .css, .scss or .sass
  # and run them through the sass validator - {Canvas::Validator::Sass}.
  class ValidSassCheck < Check
    def run(scoped_files)
      sass_files(scoped_files).each do |filename|
        file = File.read(filename)
        validator = Validator::Sass.new(file)

        next if validator.validate

        validator.errors.each do |message|
          @offenses << Offense.new(
            message: "Invalid Sass: #{filename} - \n#{message}"
          )
        end
      end
    end

    private

    def sass_files(scoped_files)
      all_files = Dir.glob("**/*.{css,scss,sass}")
      if scoped_files.any?
        all_files & scoped_files
      else
        all_files
      end
    end
  end
end
