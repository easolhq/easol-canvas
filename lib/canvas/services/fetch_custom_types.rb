# frozen_string_literal: true

require "json"

module Canvas
  # :documented:
  # This service can be used to fetch the custom types from the /types directory.
  class FetchCustomTypes
    class << self
      # @return [Array<Hash>] a list of all the custom types defined in the
      # theme within the /types directory.
      def call
        filenames = Dir.glob("types/*.json")
        filenames.map { |filename| extract_json(filename) }.compact
      end

      private

      def extract_json(filename)
        file = File.read(filename)
        JSON.parse(file)
      rescue JSON::ParserError
        nil
      end
    end
  end
end
