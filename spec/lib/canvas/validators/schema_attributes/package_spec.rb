# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Package do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Package.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      let(:attribute) {
        {
          "name" => "my_package",
          "type" => "package",
          "default" => default_value
        }
      }

      context "when unknown default value is provided" do
        let(:default_value) { "FAIL" }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for package-type variables must be one of: random"
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
            "name" => "my_package",
            "type" => "package",
            "array" => true,
            "default" => %w[random modnar]
          }
        }
        it "returns false" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for package-type variables must be one of: random"
          )
        end
      end

      context "when `default` is an array of valid options" do
        let(:attribute) {
          {
            "name" => "my_package",
            "type" => "package",
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
