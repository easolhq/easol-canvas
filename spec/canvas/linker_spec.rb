describe Canvas::Linker do
  include ExampleDirectoryHelper

  describe "#link" do
    it "adds the path specified and the resource to the list of links in the config" do
      copy_example_directory("vagabond")

      Canvas::Linker.new.link("blocks/hero/block.liquid", 12345)

      expect(Canvas::Config.get(:links)).to eq ({
        "blocks/hero/block.liquid" => 12345
      })
    end

    it "raises a Linker::Error if the path doesn't exist" do
      expect {
        Canvas::Linker.new.link("fake.txt", 12345)
      }.to raise_error Canvas::Linker::Error, "fake.txt No such file"
    end

    it "raises a Linker::Error if the path is a directory" do
      copy_example_directory("vagabond")

      expect {
        Canvas::Linker.new.link("blocks", 12345)
      }.to raise_error Canvas::Linker::Error, "blocks is a directory"
    end

    it "apends new links to the list of links" do
      copy_example_directory("alchemist")

      Canvas::Linker.new.link("blocks/hero/block.liquid", 12345)
      Canvas::Linker.new.link("blocks/image/block.liquid", 6789)

      expect(Canvas::Config.get(:links)).to eq ({
        "blocks/hero/block.liquid" => 12345,
        "blocks/image/block.liquid" => 6789
      })
    end

    it "overwrites a link if the path is already linked" do
      copy_example_directory("alchemist")

      Canvas::Linker.new.link("blocks/hero/block.liquid", 12345)
      Canvas::Linker.new.link("blocks/hero/block.liquid", 67890)

      expect(Canvas::Config.get(:links)).to eq ({
        "blocks/hero/block.liquid" => 67890
      })
    end

    it "raises an error if the resource specified is already linked" do
      copy_example_directory("alchemist")

      Canvas::Linker.new.link("blocks/hero/block.liquid", 12345)

      expect {
        Canvas::Linker.new.link("blocks/image/block.liquid", 12345)
      }.to raise_error Canvas::Linker::Error, "12345 already linked to blocks/hero/block.liquid"
    end
  end
end
