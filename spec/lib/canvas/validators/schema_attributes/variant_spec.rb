# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Variant do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Variant.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'only_from' key" do
      it "is valid when using an array with product options" do
        all_allowed_values = Canvas::Validator::SchemaAttribute::Product::ALLOWED_RESTRICTIONS
        validator = described_class.new({
          "name" => "my_variant",
          "type" => "variant",
          "only_from" => all_allowed_values,
        })
        expect(validator.validate).to eq(true)
      end

      it "is invalid when empty as it would exclude everything" do
        validator = described_class.new({
          "name" => "my_variant",
          "type" => "variant",
          "only_from" => [],
        })
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(%["only_from" cannot be empty])
      end

      it "is invalid when using an unsupported product option" do
        validator = described_class.new({
          "name" => "my_variant",
          "type" => "variant",
          "only_from" => ["unsupported"],
        })
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(%["only_from" for variant-type variables must be one of: experiences, accommodations])
      end

      it "is invalid when not an array" do
        validator = described_class.new({
          "name" => "my_variant",
          "type" => "variant",
          "only_from" => "not an array",
        })
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(%["only_from" is a String, expected Array])
      end
    end

    describe "validating an optional 'default' key" do
      let(:attribute) {
        {
          "name" => "my_variant",
          "type" => "variant",
          "default" => default_value
        }
      }

      context "when unknown default value is provided" do
        let(:default_value) { "FAIL" }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for variant-type variables must be one of: random"
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
            "name" => "my_variant",
            "type" => "variant",
            "array" => true,
            "default" => %w[random modnar]
          }
        }
        it "returns false" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for variant-type variables must be one of: random"
          )
        end
      end

      context "when `default` is an array of valid options" do
        let(:attribute) {
          {
            "name" => "my_variant",
            "type" => "variant",
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
