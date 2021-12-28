require_relative '../../lib/canvas/cli'

describe Canvas::Cli do
  include ExampleDirectoryHelper

  subject(:cli) { Canvas::Cli.new }

  describe "list" do
    let(:output) { capture(:stdout) { subject.list } }
    it "should list all files in the current directory" do
      copy_example_directory(:alchemist)

      expect(output).to include("blocks", "templates")
    end
  end
end
