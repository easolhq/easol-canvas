module Canvas
  class ValidJsonCheck < Check
    def run
      json_files.each do |filename|
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

    def json_files
      Dir.glob("**/*.json")
    end
  end
end