# frozen_string_literal: true

describe Canvas::Validator::CustomType do
  subject(:validator) {
    Canvas::Validator::CustomType.new(schema: schema)
  }

  describe "#validate" do
    context "when schema has required keys" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            }
          ]
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when schema is nil" do
      let(:schema) { nil }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Schema is not in a valid format")
      end
    end

    context "when schema has missing keys" do
      let(:schema) { {} }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Missing required keys: key, name, attributes")
      end
    end

    context "when schema has unrecognized keys" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            }
          ],
          "unknown" => true,
          "other" => []
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Unrecognized keys: unknown, other")
      end
    end

    context "when key is not a string" do
      let(:schema) {
        {
          "key" => true,
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            }
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"key\" must be a string")
      end
    end

    context "when key is a reserved word" do
      let(:schema) {
        {
          "key" => "string",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            }
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"key\" can't be one of these reserved words: #{Canvas::Constants::PRIMITIVE_TYPES.join(', ')}")
      end
    end

    context "when name is not a string" do
      let(:schema) {
        {
          "key" => "title",
          "name" => false,
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            }
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"name\" must be a string")
      end
    end

    context "when schema has empty attributes" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => []
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"attributes\" must be an array of objects")
      end
    end

    context "when attributes contains values that are not hashes" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            },
            "invalid"
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"attributes\" must be an array of objects")
      end
    end

    context "when there are duplicate attribute names" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            },
            {
              "name" => "title",
              "type" => "text"
            }
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Some attributes are duplicated: title")
      end
    end

    context "when some attributes are not valid" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "title",
              "type" => "string"
            },
            {
              "name" => "urls",
              "type" => "string",
              "array" => "invalid"
            }
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Attribute \"urls\" is invalid - \"array\" is 'invalid', expected one of: true, false")
      end
    end

    context "when first attribute is an array" do
      let(:schema) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            {
              "name" => "titles",
              "type" => "string",
              "array" => true
            }
          ]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("The first attribute cannot be an array")
      end
    end
  end
end
