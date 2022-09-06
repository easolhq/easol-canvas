# frozen_string_literal: true

describe Canvas::ValidJsonCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidSassCheck.new }

  describe "#run" do
    it "doesn't add any errors if all files contain valid Sass" do
      copy_example_directory("vagabond")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when a file contains invalid Sass" do
      copy_example_directory("alchemist")
      subject.run

      expect(subject.offenses).to match_array(
        [
          have_attributes(
            message: include("Invalid Sass: assets/index.css") &
              include("Error: Undefined variable") &
              include("1:13") &
              include("h1 { color: $gray-100 }")
          )
        ]
      )
    end
  end
end
