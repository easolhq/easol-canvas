# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Range do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Range.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      context "unit is not a String" do
        let(:attribute) {
          {
            "name" => "cards_per_row",
            "type" => "range",
            "unit" => 2
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"unit\" is a Integer, expected String"
          )
        end
      end

      context "default is a string representing a valid range value" do
        let(:attribute) {
          {
            "name" => "cards_per_row",
            "type" => "range",
            "default" => "5",
            "min" => 0,
            "max" => 10,
            "step" => 2,
            "unit" => "cards per row"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end
  end
end
