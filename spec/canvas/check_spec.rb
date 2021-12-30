describe Canvas::Check do
  include ExampleDirectoryHelper
  subject(:check) { DummyCheck.new }

  class DummyCheck < Canvas::Check
    self.base_folder = "templates"
    require_file "product.liquid"
  end

  describe "#run" do
    describe "Checking required files" do
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
  end
end
