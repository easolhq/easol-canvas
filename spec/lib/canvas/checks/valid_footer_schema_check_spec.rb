# frozen_string_literal: true

describe Canvas::ValidFooterSchemaCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidFooterSchemaCheck.new }

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
              Invalid Footer Schema: partials/footer/index.liquid - \n
              Attribute \"my_color\" is invalid - \"label\" is a Hash, expected String
            MESSAGE
          ),
          have_attributes(
            message: <<~MESSAGE.chop.squeeze("\n")
              Invalid Footer Schema: partials/footer/index.liquid - \n
              Attribute \"my_description\" is invalid - Missing required keys: type
            MESSAGE
          )
        ]
      )
    end
  end
end
