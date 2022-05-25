# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Base do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Base.new(attribute)
  }

  describe "#validate" do
    context "when attribute is valid" do
      let(:attribute) {
        {
          "name" => "my_title",
          "type" => "text",
          "default" => "Hello world",
          "label" => "My Title",
          "hint" => "This field is important",
          "group" => "content",
          "array" => true
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when missing required keys" do
      let(:attribute) {
        {
          "label" => "My Title",
          "default" => "Hello world"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "Missing required keys: name, type"
        )
      end
    end

    context "when there are unrecognized keys" do
      let(:attribute) {
        {
          "name" => "my_title",
          "type" => "text",
          "unknown" => "Unrecognized key"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "Unrecognized keys: unknown"
        )
      end
    end

    context "when group is not from permitted list of values" do
      let(:attribute) {
        {
          "name" => "my_title",
          "type" => "text",
          "group" => "unknown"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "\"group\" is 'unknown', expected one of: content, layout, design, mobile"
        )
      end
    end

    context "when label is not a string" do
      let(:attribute) {
        {
          "name" => "my_title",
          "type" => "text",
          "label" => {
            "text" => "My Title"
          }
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "\"label\" is a Hash, expected String"
        )
      end
    end

    context "when array is not a true or false" do
      let(:attribute) {
        {
          "name" => "my_title",
          "type" => "text",
          "array" => "a string value"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "\"array\" is 'a string value', expected one of: true, false"
        )
      end
    end
  end
end
