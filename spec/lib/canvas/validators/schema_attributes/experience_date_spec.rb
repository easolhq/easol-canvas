# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::ExperienceDate do
  subject(:validator) { described_class.new(attribute) }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      let(:attribute) {
        {
          "name" => "my_date",
          "type" => "experience_date",
          "default" => default_value
        }
      }

      context "when unknown default value is provided" do
        let(:default_value) { "FAIL" }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for experience_date variables must be one of: next_upcoming"
          )
        end
      end

      context "when `next_upcoming` default value is provided" do
        let(:default_value) { "Next_upcoming" }

        it "passes the validation" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when `default` is an array of invalid options" do
        let(:attribute) {
          {
            "name" => "my_date",
            "type" => "experience_date",
            "array" => true,
            "default" => %w[next_upcoming unknown]
          }
        }
        it "returns false" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for experience_date variables must be one of: next_upcoming"
          )
        end
      end

      context "when `default` is an array of valid options" do
        let(:attribute) {
          {
            "name" => "my_variant",
            "type" => "variant",
            "array" => true,
            "default" => %w[Next_upcoming next_upcoming]
          }
        }
        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end
  end
end
