# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Color do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Color.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      context "default is not a Hash" do
        let(:attribute) {
          {
            "name" => "background_color",
            "type" => "color",
            "default" => "blue"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" is a String, expected Hash"
          )
        end
      end

      context "the default is a hash that is not palette or rgba" do
        let(:attribute) {
          {
            "name" => "background_color",
            "type" => "color",
            "default" => {
              "unknown" => "primary"
            }
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for color-type variables must include palette or rgba values"
          )
        end
      end

      context "Palette values" do
        context "the default is a valid Palette value" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "palette" => "primary"
              }
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end

        context "the default is an invalid Palette value" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "palette" => "unknown"
              }
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" value for palette color-type must be one of "\
              "the following values: #{Canvas::Constants::COLOR_PALETTE_VALUES.join(', ')}"
            )
          end
        end

        context "the default is has a Palette value and rgba values" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "palette" => "primary",
                "r" => "0",
                "g" => "0",
                "b" => "0",
                "a" => "1"
              }
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end
      end

      context "RGBA values" do
        context "the default alpha value given is outside of the valid range" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "0",
                "g" => "0",
                "b" => "0",
                "a" => "2.5"
              }
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" values for color-type variables must be between 0 and 255 for rgb, and between 0 and 1 for a"
            )
          end
        end

        context "the default alpha value given is not a valid float" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "0",
                "g" => "0",
                "b" => "0",
                "a" => "string"
              }
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" values for color-type variables must be between 0 and 255 for rgb, and between 0 and 1 for a"
            )
          end
        end

        context "a default RGB value is not a number" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "255",
                "g" => "0",
                "b" => "hello"
              }
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" values for color-type variables must be between 0 and 255 for rgb, and between 0 and 1 for a"
            )
          end
        end

        context "a default RGB value is a number outside of the valid range" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "255",
                "g" => "255",
                "b" => "256"
              }
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" values for color-type variables must be between 0 and 255 for rgb, and between 0 and 1 for a"
            )
          end
        end

        context "default is a Hash with invalid keys" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "255",
                "w" => "255"
              }
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" for color-type variables must include palette or rgba values"
            )
          end
        end

        context "default is supplied with valid 'r', 'g', 'b' and 'a' values" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "255",
                "g" => "190",
                "b" => "40",
                "a" => "0.5"
              }
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end

        context "default is supplied with valid 'r', 'g', and 'b' values" do
          let(:attribute) {
            {
              "name" => "background_color",
              "type" => "color",
              "default" => {
                "r" => "255",
                "g" => "255",
                "b" => "15"
              }
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end
      end
    end
  end
end
