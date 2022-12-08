# frozen_string_literal: true

module Canvas
  # :documented:
  # This check will validate the schema defined in the front matter
  # within each footer template file.
  #
  # Example of footer Liquid with valid front matter:
  #
  # ---
  # max_item_levels: 2
  # supports_open_new_tab: true
  # attributes:
  #   my_title:
  #     type: string
  #   my_color:
  #     type: color
  #     label: My color
  #     hint: "Select your favourite color"
  # ---
  #
  # <p>My footer HTML</p>
  #
  class ValidFooterSchemaCheck < Check
    def run(scoped_files)
      return unless scoped_files.include? footer_filename
      file = File.read(footer_filename)
      front_matter = extract_front_matter(file)
      validate_format(front_matter) &&
        validate_schema(front_matter)
    end

    private

    def footer_filename
      Dir.glob("partials/footer/index.{html,liquid}").first
    end

    def validate_format(front_matter)
      return true if front_matter.is_a?(Hash) && attributes_valid_format(front_matter)

      @offenses << Offense.new(
        message: "Invalid Footer Schema: #{footer_filename} - \nSchema is not in a valid format"
      )
      false
    end

    def attributes_valid_format(front_matter)
      return true unless front_matter.key?("attributes")

      front_matter["attributes"].is_a?(Hash) &&
        front_matter["attributes"].values.all? { |attr| attr.is_a?(Hash) }
    end

    def validate_schema(schema)
      validator = Validator::FooterSchema.new(
        schema: schema,
        custom_types: Canvas::FetchCustomTypes.call
      )
      return if validator.validate

      validator.errors.each do |message|
        @offenses << Offense.new(
          message: "Invalid Footer Schema: #{footer_filename} - \n#{message}"
        )
      end
    end

    def extract_front_matter(file)
      extractor = Canvas::FrontMatterExtractor.new(file)
      front_matter = extractor.front_matter
      front_matter.nil? ? {} : YAML.safe_load(front_matter)
    end
  end
end
