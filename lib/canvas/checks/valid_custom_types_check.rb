# frozen_string_literal: true

module Canvas
  # :documented:
  # This check will validate the JSON objects that represent the
  # custom types that are defined in the /types directory.
  class ValidCustomTypesCheck < Check
    def run
      custom_type_files.each do |filename|
        schema = extract_json(filename)
        validator = Validator::CustomType.new(schema: schema)

        next if validator.validate

        validator.errors.each do |message|
          @offenses << Offense.new(
            message: "Invalid Custom Type: #{filename} - \n#{message}"
          )
        end
      end
    end

    private

    def custom_type_files
      Dir.glob("types/*.json")
    end

    def extract_json(filename)
      file = File.read(filename)
      JSON.parse(file)
    rescue JSON::ParserError
      nil
    end
  end
end
