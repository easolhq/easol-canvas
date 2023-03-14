# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Product do
  subject(:validator) { described_class.new(attribute) }

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

      context "when `only` is provided" do
        it "is valid when using an array" do
          all_allowed_values = %w[experiences accommodations extras]
          validator = described_class.new({
            "name" => "my_product",
            "type" => "product",
            "only" => all_allowed_values,
          })
          expect(validator.validate).to eq(true)
        end

        it "is invalid when empty as it would exclude everything" do
          validator = described_class.new({
            "name" => "my_product",
            "type" => "product",
            "only" => [],
          })
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(%["only" cannot be empty])
        end

        it "is invalid when using unsupported option" do
          validator = described_class.new({
            "name" => "my_product",
            "type" => "product",
            "only" => ["unsupported"],
          })
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(%["only" for product-type variables must be one of: experiences, accommodations, extras])
        end

        it "is invalid when not an array" do
          validator = described_class.new({
            "name" => "my_product",
            "type" => "product",
            "only" => "not an array",
          })
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(%["only" is a String, expected Array])
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
