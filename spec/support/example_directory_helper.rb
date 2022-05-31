# frozen_string_literal: true

require "fileutils"

module ExampleDirectoryHelper
  def copy_example_directory(example_directory)
    examples_base_directory = File.expand_path("../../examples", __FILE__)
    example_directory_path = File.join(examples_base_directory, example_directory.to_s)

    files = Dir.new(example_directory_path).entries.
      reject { |f| f.start_with?(".") }.
      map { |f| File.join(example_directory_path, f) }

    FileUtils.cp_r(files, @directory)
  end
end
