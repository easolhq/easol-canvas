# frozen_string_literal: true

describe Canvas::ValidBlockSchemasCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidBlockSchemasCheck.new }

  describe "#run" do
    it "doesn't add any errors if all blocks contain valid schemas" do
      copy_example_directory("vagabond")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when a block contains an invalid schema" do
      copy_example_directory("alchemist")
      subject.run

      expect(subject.offenses).to match_array(
        [
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Block Schema: blocks/heading/block.liquid - \n
              Unrecognized keys: wrong_level
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Block Schema: blocks/image/block.liquid - \n
              Schema is not in a valid format
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Block Schema: blocks/hero/block.liquid - \n
              Attribute \"image\" is invalid - Missing required keys: type
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Block Schema: blocks/text_with_layout/block.liquid - \n
              Unrecognized attribute `unknown`. Location: layout/0/elements/2
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Block Schema: blocks/invalid_yaml/block.liquid - \n
              Front matter's YAML is not in a valid format
            MESSAGE
          )
        ]
      )
    end
  end
end
