# frozen_string_literal: true

describe Canvas::ValidHtmlCheck do
  include ExampleDirectoryHelper
  subject(:check) { Canvas::ValidHtmlCheck.new }

  describe "#run" do
    it "doesn't add any errors if the files html is valid ( Or valid liquid )" do
      copy_example_directory("vagabond")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when the file isn't valid html" do
      copy_example_directory("alchemist")
      subject.run
      message = <<~MESSAGE.chop
        Invalid HTML: blocks/hero/block.liquid - \n
        14:16: ERROR: Start tag of nonvoid HTML element ends with '/>', use '>'.
        <h1>xxxxxxxxxxx<foo/>
                       ^
      MESSAGE

      expect(subject.offenses).to match_array(
        [
          have_attributes(message: message.squeeze("\n"))
        ]
      )
    end
  end
end
