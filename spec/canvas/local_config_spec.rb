describe Canvas::LocalConfig do
  describe "#set" do
    it "sets a persisted value in the config store" do
      Canvas::LocalConfig.set(foo: "bar")

      expect(Canvas::LocalConfig.get(:foo)).to eq "bar"
    end

    it "accepts multiple arguments" do
      Canvas::LocalConfig.set(foo: "bar", baz: "qux")

      expect(Canvas::LocalConfig.get(:foo)).to eq "bar"
      expect(Canvas::LocalConfig.get(:baz)).to eq "qux"
    end

    it "allows setting a value to nil" do
      Canvas::LocalConfig.set(foo: "bar")
      Canvas::LocalConfig.set(foo: nil)

      expect(Canvas::LocalConfig.get(:foo)).to be_nil
    end
  end

  describe "#get" do
    before do
      Canvas::LocalConfig.set(foo: "bar")
    end

    it "returns the value in the config at the key specified" do
      expect(Canvas::LocalConfig.get(:foo)).to eq "bar"
    end

    it "returns nil if the key isn't found" do
      expect(Canvas::LocalConfig.get(:bar)).to be_nil
    end
  end

  describe "#delete" do
    before do
      Canvas::LocalConfig.set(foo: "bar")
    end

    it "removes the value from the config" do
      expect(Canvas::LocalConfig.get(:foo)).to eq "bar"
      Canvas::LocalConfig.delete(:foo)
      expect(Canvas::LocalConfig.get(:foo)).to be_nil
    end
  end
end
