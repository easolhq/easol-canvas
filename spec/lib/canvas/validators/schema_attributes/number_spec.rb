# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Number do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Number.new(attribute)
  }

  describe "#validate" do
    context "validating optional keys" do
      context "an optional key is specified with an invalid type" do
        let(:attribute) {
          {
            "name" => "number_of_cards",
            "type" => "number",
            "unit" => false
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"unit\" is a FalseClass, expected String"
          )
        end
      end

      context "optional keys are all valid" do
        let(:attribute) {
          {
            "name" => "number_of_cards",
            "type" => "number",
            "array" => false,
            "label" => "Number of cards to show per row",
            "hint" => "We recommend 3 cards per row",
            "group" => "layout",
            "unit" => "cards"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end
  end
end
