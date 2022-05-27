describe Canvas::ValidJsonCheck do
  include ExampleDirectoryHelper

  subject(:check) { Canvas::ValidJsonCheck.new }

  describe "#run" do
    it "doesn't add any errors if all files contain valid json" do
      copy_example_directory("alchemist")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when a file contains invalid json" do
      copy_example_directory("vagabond")
      subject.run
      message = "unexpected token at 'This is an invalid custom type."

      expect(subject.offenses).to match_array(
        [
          have_attributes(message: include(message.squeeze("\n")))
        ]
      )
    end
  end
end
