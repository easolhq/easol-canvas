# frozen_string_literal: true

module Canvas
  # :documented:
  # This service will convert the attributes from a hash, as they are defined in the front matter,
  # into an array of hashes that the {Canvas::Validator::SchemaAttribute} class expects.
  # e.g. the following front matter:
  #
  # my_title:
  #   type: string
  # my_color:
  #   type: color
  #
  # will get converted to:
  #
  # [
  #   {
  #     "name" => "my_title",
  #     "type" => "string"
  #   },
  #   {
  #     "name" => "my_color",
  #     "type" => "color"
  #   }
  # ]
  #
  class ExpandAttributes
    class << self
      # @param attributes_hash [Hash] hash of attributes pulled from front matter
      # @return [Array<Hash>] array of hashes that represent each attribute
      def call(attributes_hash)
        return [] if attributes_hash.nil?

        attributes_hash.each_with_object([]) do |(name, attribute_hash), attrs|
          attrs << attribute_hash.merge("name" => name)
        end
      end
    end
  end
end
