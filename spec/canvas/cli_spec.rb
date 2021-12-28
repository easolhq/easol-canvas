require_relative '../../lib/canvas/cli'

describe Canvas::Cli do
  subject(:cli) { Canvas::Cli.new }
  describe "list" do
    let(:output) { capture(:stdout) { subject.list } }
    it "should list all files in the current directory" do
      File.open("foo.txt", "w") do |f|     
        f.write("whatever")   
      end

      expect(output).to include("foo.txt")
    end
  end
end
