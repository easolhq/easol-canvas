describe Canvas::GlobalConfig do
  describe "#set" do
    it "sets a persisted value in the config store" do
      Canvas::GlobalConfig.set(foo: "bar")

      expect(Canvas::GlobalConfig.get(:foo)).to eq "bar"
    end

    it "accepts multiple arguments" do
      Canvas::GlobalConfig.set(foo: "bar", baz: "qux")

      expect(Canvas::GlobalConfig.get(:foo)).to eq "bar"
      expect(Canvas::GlobalConfig.get(:baz)).to eq "qux"
    end

    it "allows setting a value to nil" do
      Canvas::GlobalConfig.set(foo: "bar")
      Canvas::GlobalConfig.set(foo: nil)

      expect(Canvas::GlobalConfig.get(:foo)).to be_nil
    end
  end

  describe "#get" do
    before do
      Canvas::GlobalConfig.set(foo: "bar")
    end

    it "returns the value in the config at the key specified" do
      expect(Canvas::GlobalConfig.get(:foo)).to eq "bar"
    end

    it "returns nil if the key isn't found" do
      expect(Canvas::GlobalConfig.get(:bar)).to be_nil
    end
  end
end
