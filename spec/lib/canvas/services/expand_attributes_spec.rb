# frozen_string_literal: true

describe Canvas::ExpandAttributes do
  describe ".call" do
    it "returns an array of hashes represent each attribute" do
      attributes_hash = {
        "my_title" => {
          "type" => "string"
        },
        "my_color" => {
          "type" => "color",
          "label" => "My color"
        }
      }

      expect(Canvas::ExpandAttributes.call(attributes_hash)).to eq(
        [
          {
            "name" => "my_title",
            "type" => "string"
          },
          {
            "name" => "my_color",
            "type" => "color",
            "label" => "My color"
          }
        ]
      )
    end

    it "returns unchanged input when attributes_hash is array" do
      attributes_hash = ["test"]

      expect(Canvas::ExpandAttributes.call(attributes_hash)).to eq(attributes_hash)
    end

    it "returns empty array when attributes_hash is nil" do
      expect(Canvas::ExpandAttributes.call(nil)).to eq([])
    end
  end
end
