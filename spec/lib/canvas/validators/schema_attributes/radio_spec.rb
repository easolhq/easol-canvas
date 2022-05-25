# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Radio do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Radio.new(attribute)
  }

  describe "#validate" do
    describe "validating optional default field" do
      context "value not included in options" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "radio",
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
            "type" => "radio",
            "options" => []
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "Must provide at least 1 option for radio type variable"
          )
        end
      end

      context "ensure each option is valid" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "radio",
            "options" => [
              { "label" => "Top", "value" => "top" },
              { "label" => "Middle", "value" => "middle" },
              { "label" =>  "Bottom", "valu" => "bottom" }
            ]
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "All options for radio type variable must specify a label and value"
          )
        end
      end

      context "options are valid" do
        let(:attribute) {
          {
            "name" => "vertical_alignment",
            "type" => "radio",
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
