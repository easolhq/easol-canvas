describe Canvas::RequiredFilesCheck do
  include ExampleDirectoryHelper
  subject(:check) { Canvas::RequiredFilesCheck.new }

  describe "#run" do
    it "doesn't add any errors if all the required files are present" do
      copy_example_directory("alchemist")
      subject.run
      expect(subject.offenses).to be_empty
    end

    it "adds an offense when the theme is any of the required files" do
      copy_example_directory("vagabond")
      subject.run

      # There are other missing file offenses on this theme but it felt like
      # overkill to check all of them
      expect(subject.offenses).to include(
        have_attributes(
          message: "Missing file: templates/product/index.{html,liquid}"
        )
      )
    end
  end
end
