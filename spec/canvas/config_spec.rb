describe Canvas::Config do
  describe "#set" do
    it "sets a persisted value in the config store" do
      Canvas::Config.new.set(foo: "bar")

      expect(Canvas::Config.new.get(:foo)).to eq "bar"
    end

    it "accepts multiple arguments" do
      Canvas::Config.new.set(foo: "bar", baz: "qux")

      expect(Canvas::Config.new.get(:foo)).to eq "bar"
      expect(Canvas::Config.new.get(:baz)).to eq "qux"
    end

    it "allows setting a value to nil" do
      Canvas::Config.new.set(foo: "bar")
      Canvas::Config.new.set(foo: nil)

      expect(Canvas::Config.new.get(:foo)).to be_nil
    end
  end

  describe "#get" do
    before do
      Canvas::Config.new.set(foo: "bar")
    end

    it "returns the value in the config at the key specified" do
      expect(Canvas::Config.new.get(:foo)).to eq "bar"
    end

    it "returns nil if the key isn't found" do
      expect(Canvas::Config.new.get(:bar)).to be_nil
    end
  end

  describe "#merge" do
    it "lets you add a key and value to the key" do
      Canvas::Config.new.merge(:foo, bar: "baz")
      Canvas::Config.new.merge(:foo, qux: "foo")

      expect(Canvas::Config.new.get(:foo)).to eq ({
        bar: "baz",
        qux: "foo"
      })
    end

    it "initializes a hash if one isn't set" do
      Canvas::Config.new.merge(:foo, bar: "baz")

      expect(Canvas::Config.new.get(:foo)).to eq ({
        bar: "baz"
      })
    end
  end
end
