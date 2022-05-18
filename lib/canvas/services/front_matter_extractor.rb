# frozen_string_literal: true
module Canvas
  # :documented:
  # This service can be used to extract front matter from a liquid string.
  class FrontMatterExtractor
    attr_accessor :front_matter, :html

    def initialize(full_markup)
      @front_matter = extract_front_matter(full_markup)
      @html = extract_html(full_markup)
    end

    private

    # @return [String] the front matter, with the rest of the HTML stripped out
    def extract_front_matter(full_markup)
      return if full_markup.nil?

      front_matter, body = scan(full_markup)
      front_matter unless [nil, ""].include?(body)
    end

    # @return [String] the HTML, with the front matter stripped out
    def extract_html(full_markup)
      return if full_markup.nil?

      liquid_markup_stripped = full_markup.gsub("\n\n", "\n")
      _, body = scan(liquid_markup_stripped)
      body || full_markup
    end

    # @return [Array<String>] an array consisting of two items: the front matter
    # and the HTML content.
    def scan(markup)
      markup = markup.gsub(/\t/, "  ")
      [*markup.match(/(?:---\s+(.*?)\s+---\s+)(.*\s?)$/m)&.captures]
    end
  end
end
