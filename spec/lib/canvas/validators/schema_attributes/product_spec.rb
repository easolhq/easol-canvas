# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Product do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Product.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      let(:attribute) {
        {
          "name" => "my_product",
          "type" => "product",
          "default" => default_value
        }
      }

      context "when unknown default value is provided" do
        let(:default_value) { "FAIL" }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for product-type variables must be one of: random"
          )
        end
      end

      context "when `random` default value is provided" do
        let(:default_value) { "Random" }

        it "passes the validation" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when `default` is an array of invalid options" do
        let(:attribute) {
          {
            "name" => "my_product",
            "type" => "product",
            "array" => true,
            "default" => %w[random modnar]
          }
        }
        it "returns false" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for product-type variables must be one of: random"
          )
        end
      end

      context "when `default` is an array of valid options" do
        let(:attribute) {
          {
            "name" => "my_product",
            "type" => "product",
            "array" => true,
            "default" => %w[Random random]
          }
        }
        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end
  end
end
