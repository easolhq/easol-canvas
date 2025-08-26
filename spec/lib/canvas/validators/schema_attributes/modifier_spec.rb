# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Modifier do
  subject(:validator) { described_class.new(attribute) }

  describe "#validate" do
    context "when the attribute has only required keys" do
      let(:attribute) {
        {
          "name" => "my_modifier",
          "type" => "modifier"
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when the attribute has optional keys" do
      let(:attribute) {
        {
          "name" => "featured_modifier",
          "type" => "modifier",
          "label" => "Featured Modifier",
          "hint" => "Select a modifier to feature",
          "group" => "content"
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    describe "validating an optional 'default' key" do
      context "when unknown default value is provided" do
        let(:attribute) {
          {
            "name" => "my_modifier",
            "type" => "modifier",
            "default" => "invalid_value"
          }
        }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for modifier-type variables must be one of: random"
          )
        end
      end

      context "when 'random' default value is provided" do
        let(:attribute) {
          {
            "name" => "my_modifier",
            "type" => "modifier",
            "default" => "random"
          }
        }

        it "passes the validation" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when 'Random' (capitalized) default value is provided" do
        let(:attribute) {
          {
            "name" => "my_modifier",
            "type" => "modifier",
            "default" => "Random"
          }
        }

        it "passes the validation" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when modifier is an array" do
        context "when 'default' is an array of invalid options" do
          let(:attribute) {
            {
              "name" => "my_modifiers",
              "type" => "modifier",
              "array" => true,
              "default" => %w[random invalid_value]
            }
          }

          it "returns false" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" for modifier-type variables must be one of: random"
            )
          end
        end

        context "when 'default' is an array of valid options" do
          let(:attribute) {
            {
              "name" => "my_modifiers",
              "type" => "modifier",
              "array" => true,
              "default" => %w[Random random]
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end

        context "when 'default' is not an array for array type" do
          let(:attribute) {
            {
              "name" => "my_modifiers",
              "type" => "modifier",
              "array" => true,
              "default" => "random"
            }
          }

          it "returns false" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" is a String, expected Array"
            )
          end
        end
      end

      context "when modifier is not an array" do
        context "when 'default' is an array for non-array type" do
          let(:attribute) {
            {
              "name" => "my_modifier",
              "type" => "modifier",
              "default" => ["random"]
            }
          }

          it "returns false" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" is a Array, expected String"
            )
          end
        end
      end
    end

    describe "array support" do
      context "when modifier is defined as an array" do
        let(:attribute) {
          {
            "name" => "modifier_list",
            "type" => "modifier",
            "array" => true
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when modifier array has a valid default" do
        let(:attribute) {
          {
            "name" => "modifier_list",
            "type" => "modifier",
            "array" => true,
            "default" => ["random"]
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end

    describe "inheritance from base validator" do
      context "when missing required 'name' key" do
        let(:attribute) {
          {
            "type" => "modifier"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Missing required keys: name")
        end
      end

      context "when missing required 'type' key" do
        let(:attribute) {
          {
            "name" => "my_modifier"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Missing required keys: type")
        end
      end

      context "when using unrecognized keys" do
        let(:attribute) {
          {
            "name" => "my_modifier",
            "type" => "modifier",
            "invalid_key" => "value"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Unrecognized keys: invalid_key")
        end
      end

      context "when name is not a string" do
        let(:attribute) {
          {
            "name" => 123,
            "type" => "modifier"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("\"name\" is a Integer, expected String")
        end
      end

      context "when array is not a boolean" do
        let(:attribute) {
          {
            "name" => "my_modifier",
            "type" => "modifier",
            "array" => "yes"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("\"array\" is 'yes', expected one of: true, false")
        end
      end
    end
  end
end
