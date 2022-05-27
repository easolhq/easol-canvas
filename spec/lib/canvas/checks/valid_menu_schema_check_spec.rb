# frozen_string_literal: true

describe Canvas::ValidMenuSchemaCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidMenuSchemaCheck.new }

  describe "#run" do
    it "doesn't add any errors if the menu contains a valid schema" do
      copy_example_directory("vagabond")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when the menu contains an invalid schema" do
      copy_example_directory("alchemist")
      subject.run

      expect(subject.offenses).to match_array(
        [
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Menu Schema: partials/menu/index.liquid - \n
              \"max_item_levels\" must be a number between 1 and 3
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Menu Schema: partials/menu/index.liquid - \n
              Attribute \"my_title\" is invalid - Missing required keys: type
            MESSAGE
          )
        ]
      )
    end
  end
end
