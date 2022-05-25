# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Select do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Select.new(attribute)
  }

  describe "#validate" do
    describe "validating optional default field" do
      context "value not included in options" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "select",
            "options" => [{ "label" => "Top", "value" => "top" }],
            "default" => "bottom"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" is 'bottom', expected one of: top"
          )
        end
      end
    end
    describe "validating required options field" do
      context "at least one option is required" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "select",
            "options" => []
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "Must provide at least 1 option for select type variable"
          )
        end
      end

      context "options aren't provided as hashes" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "select",
            "options" => [1, 2, 3]
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "All options for select type variable must specify a label and value"
          )
        end
      end

      context "an option is missing the correct keys" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "select",
            "options" => [
              { "label" => "Top", "value" => "top" },
              { "label" => "Middle", "value" => "middle" },
              { "label" => "Bottom", "valu" => "bottom" }
            ]
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "All options for select type variable must specify a label and value"
          )
        end
      end

      context "options are valid" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "select",
            "options" => [
              { "label" => "Top", "value" => "top" },
              { "label" => "Middle", "value" => "middle" },
              { "label" => "Bottom", "value" => "bottom" }
            ]
          }
        }
        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end
  end
end
