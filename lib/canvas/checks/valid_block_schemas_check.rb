# frozen_string_literal: true

module Canvas
  # :documented:
  # This check will validate the schema defined in the front matter
  # within each block template file.
  #
  # Example of block Liquid with valid front matter:
  #
  # ---
  # my_title:
  #   type: string
  # my_color:
  #   type: color
  #   label: My color
  #   hint: "Select your favourite color"
  # ---
  #
  # <p>My block HTML</p>
  #
  class ValidBlockSchemasCheck < Check
    def run
      custom_types = Canvas::FetchCustomTypes.call
      block_files.each do |filename|
        file = File.read(filename)
        front_matter = extract_front_matter(file)
        validate_format(filename, front_matter) &&
          validate_schema(filename, front_matter, custom_types)
      end
    end

    private

    def block_files
      Dir.glob("blocks/**/*.{html,liquid}")
    end

    def validate_format(filename, front_matter)
      return true if front_matter.is_a?(Hash) &&
                     front_matter.values.all? { |attr| attr.is_a?(Hash) }

      @offenses << Offense.new(
        message: "Invalid Block Schema: #{filename} - \nSchema is not in a valid format"
      )
      false
    end

    def validate_schema(filename, front_matter, custom_types)
      schema = extract_schema(front_matter)
      validator = Validator::BlockSchema.new(schema: schema, custom_types: custom_types)
      return if validator.validate

      validator.errors.each do |message|
        @offenses << Offense.new(
          message: "Invalid Block Schema: #{filename} - \n#{message}"
        )
      end
    end

    def extract_front_matter(file)
      extractor = Canvas::FrontMatterExtractor.new(file)
      front_matter = extractor.front_matter
      front_matter.nil? ? {} : YAML.safe_load(front_matter)
    end

    def extract_schema(front_matter)
      {
        "attributes" => Canvas::ExpandAttributes.call(front_matter)
      }
    end
  end
end
