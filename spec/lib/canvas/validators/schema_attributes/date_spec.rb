# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Date do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Date.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      let(:attribute) {
        {
          "name" => "departure_date",
          "type" => "date",
          "default" => default_value
        }
      }

      context "when unknown default value is provided" do
        let(:default_value) { "FAIL" }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for date-type variables must be one of: today"
          )
        end
      end

      context "when `today` default value is provided" do
        let(:default_value) { "today" }

        it "passes the validation" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when `default` is an array of invalid options" do
        let(:attribute) {
          {
            "name" => "my_date",
            "type" => "date",
            "array" => true,
            "default" => %w[random modnar]
          }
        }
        it "returns false" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for date-type variables must be one of: today"
          )
        end
      end

      context "when `default` is an array of valid options" do
        let(:attribute) {
          {
            "name" => "my_date",
            "type" => "date",
            "array" => true,
            "default" => %w[today Today]
          }
        }
        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end
  end
end
