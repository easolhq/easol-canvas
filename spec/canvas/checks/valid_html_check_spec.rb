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
      message = <<~EOS.chop
        Invalid HTML: templates/blog_post/index.liquid - 
        1:19: ERROR: Start tag of nonvoid HTML element ends with '/>', use '>'.\n
        <h1>{{post.title}}<foo/>\n
                          ^
      EOS
      expect(subject.offenses).to match_array([
        have_attributes(
          message: message.squeeze("\n")
        )
      ])
    end
  end
end
