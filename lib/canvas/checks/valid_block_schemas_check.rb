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
    def run(scoped_files)
      custom_types = Canvas::FetchCustomTypes.call
      block_files(scoped_files).each do |filename|
        front_matter = extract_front_matter(filename)
        next unless front_matter

        validate_format(filename, front_matter) &&
          validate_schema(filename, front_matter, custom_types)
      end
    end

    private

    def block_files(scoped_files)
      all_files = Dir.glob("blocks/**/*.{html,liquid}")
      if scoped_files.any?
        all_files & scoped_files
      else
        all_files
      end
    end

    def validate_format(filename, front_matter)
      return true if front_matter.is_a?(Hash) &&
                     (front_matter.key?("attributes") ? front_matter["attributes"] : front_matter).values.all? { |attr| attr.is_a?(Hash) }


      @offenses << Offense.new(
        message: "Invalid Block Schema: #{filename} - \nSchema is not in a valid format"
      )
      false
    end

    def validate_schema(filename, schema, custom_types)
      validator = Validator::BlockSchema.new(schema: schema, custom_types: custom_types)
      return if validator.validate

      validator.errors.each do |message|
        @offenses << Offense.new(
          message: "Invalid Block Schema: #{filename} - \n#{message}"
        )
      end
    end

    def extract_front_matter(filename)
      file = File.read(filename)

      extractor = Canvas::FrontMatterExtractor.new(file)
      front_matter = extractor.front_matter
      front_matter.nil? ? {} : YAML.safe_load(front_matter)
    rescue Psych::SyntaxError
      @offenses << Offense.new(
        message: "Invalid Block Schema: #{filename} - \nFront matter's YAML is not in a valid format"
      )

      nil
    end
  end
end
