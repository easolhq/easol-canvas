# frozen_string_literal: true

describe Canvas::Validator::Json do
  describe "#validate" do
    it "returns true if it is valid json" do
      json = <<-EOS
        {
          "foo": "bar"
        }
      EOS
      expect(Canvas::Validator::Json.new(json).validate).to be_truthy
    end

    it "returns false if is invalid json" do
      json = <<-EOS
        {
          "foo": "bar",
        }
      EOS
      expect(Canvas::Validator::Json.new(json).validate).to be_falsey
    end
  end
end
