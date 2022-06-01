# frozen_string_literal: true

describe Canvas::ValidCustomTypesCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidCustomTypesCheck.new }

  describe "#run" do
    it "doesn't add any errors if all files contain valid custom types" do
      copy_example_directory("alchemist")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when a file contains an invalid custom type" do
      copy_example_directory("vagabond")
      subject.run

      expect(subject.offenses).to match_array(
        [
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Custom Type: types/faq.json - \n
              Attribute \"question\" is invalid - Missing required keys: type
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Custom Type: types/card.json - \n
              Schema is not in a valid format
            MESSAGE
          )
        ]
      )
    end
  end
end
