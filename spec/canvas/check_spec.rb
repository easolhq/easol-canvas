describe Canvas::Check do
  include ExampleDirectoryHelper
  subject(:check) { DummyCheck.new }

  describe "#run" do
    describe "Checking required files" do
      before do
        stub_const(
          "DummyCheck",
          Class.new(Canvas::Check) {
            self.base_folder = "templates"
            require_file "product/index.liquid"
          }
        )
      end

      it "doesn't add any errors if all the required files are present" do
        copy_example_directory("alchemist")
        subject.run
        expect(subject.offenses).to be_empty
      end

      it "adds an offense when the theme is any of the required files" do
        copy_example_directory("vagabond")
        subject.run
        expect(subject.offenses).to match_array([
          have_attributes(
            message: "Missing file: product/index.liquid"
          )
        ])
      end
    end

    describe "Checking html formats" do
      before do
        stub_const(
          "DummyCheck",
          Class.new(Canvas::Check) {
            self.base_folder = "templates"
            validate_html "blog_post/index.liquid"
          }
        )
      end

      it "doesn't add any errors if the files html is valid ( Or valid liquid )" do
        copy_example_directory("vagabond")
        subject.run
        expect(subject.offenses).to be_empty
      end

      it "adds an offense when the file isn't valid html" do
        copy_example_directory("alchemist")
        subject.run
        expect(subject.offenses).to match_array([
          have_attributes(
            message: "Invalid HTML: templates/blog_post/index.liquid - 1:25: ERROR: Unexpected end tag : foo"
          )
        ])
      end
    end
  end
end
