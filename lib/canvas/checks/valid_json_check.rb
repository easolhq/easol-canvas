# frozen_string_literal: true

module Canvas
  # :documented:
  class ValidJsonCheck < Check
    def run(scoped_files)
      json_files(scoped_files).each do |filename|
        file = File.read(filename)
        validator = Validator::Json.new(file)

        next if validator.validate

        validator.errors.each do |message|
          @offenses << Offense.new(
            message: "Invalid JSON: #{filename} - \n#{message}"
          )
        end
      end
    end

    private

    def json_files(scoped_files)
      all_files = Dir.glob("**/*.json")
      if scoped_files.any?
        all_files & scoped_files
      else
        all_files
      end
    end
  end
end
