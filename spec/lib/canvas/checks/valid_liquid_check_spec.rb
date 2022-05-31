# frozen_string_literal: true

describe Canvas::ValidLiquidCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidLiquidCheck.new }

  describe "#run" do
    it "doesn't add any errors if all files contain valid liquid" do
      copy_example_directory("vagabond")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when a file contains invalid liquid" do
      copy_example_directory("alchemist")
      subject.run
      message = <<~MESSAGE.chop
        Invalid Liquid: templates/blog_post/index.liquid - \n
        Liquid syntax error (line 2): 'if' tag was never closed
      MESSAGE

      expect(subject.offenses).to match_array(
        [
          have_attributes(message: message.squeeze("\n"))
        ]
      )
    end
  end
end
