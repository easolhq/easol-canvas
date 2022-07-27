# frozen_string_literal: true

describe Canvas::Validator::MenuSchema do
  describe "#validate" do
    subject(:validator) {
      Canvas::Validator::MenuSchema.new(schema: schema)
    }

    describe "#validate" do
      context "when schema is valid" do
        let(:schema) {
          {
            "max_item_levels" => 2
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when schema is empty" do
        let(:schema) {
          {}
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when schema is not a hash" do
        let(:schema) { nil }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Schema is not in a valid format")
        end
      end

      context "when schema has unrecognized keys" do
        let(:schema) {
          {
            "max_item_levels" => 2,
            "unknown" => true,
            "other" => []
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Unrecognized keys: unknown, other")
        end
      end

      context "when max_item_levels is nil" do
        let(:schema) {
          {
            "max_item_levels" => nil
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("\"max_item_levels\" must be a number between 1 and 3")
        end
      end

      context "when max_item_levels is a number as a string" do
        let(:schema) {
          {
            "max_item_levels" => "1"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when max_item_levels is not a number" do
        let(:schema) {
          {
            "max_item_levels" => "hello"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("\"max_item_levels\" must be a number between 1 and 3")
        end
      end

      context "when max_item_levels is greater than 3" do
        let(:schema) {
          {
            "max_item_levels" => 4
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("\"max_item_levels\" must be a number between 1 and 3")
        end
      end

      context "when the `attributes` key is not an hash" do
        let(:schema) {
          {
            "attributes" => "something wrong"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Schema is not in a valid format")
        end
      end

      context "when the `attributes` is valid" do
        let(:schema) {
          {
            "attributes" => {
              "title" => {
                "type" => "string"
              },
              "images" => {
                "type" => "image",
                "label" => "Cool image"
              }
            }
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when the `attributes` has invalid attributes" do
        let(:schema) {
          {
            "attributes" => {
              "images" => {
                "type" => "invalid"
              }
            }
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Attribute \"images\" is invalid - \"type\" must be one of: image, product, post, page, link, text, string, boolean, number, color, select, range, radio, variant")
        end
      end

      context "when the `attributes` has reserved key names" do
        let(:schema) {
          {
            "attributes" => {
              "items" => {
                "type" => "String",
                "label" => "I'm invalid"
              }
            }
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include("Attribute \"items\" is invalid - \"name\" can't be one of these reserved words: page, company, cart, flash, block, items, type")
        end
      end

      context "when schema is using a custom type" do
        let(:card_type) {
          {
            "key" => "Card",
            "name" => "Card",
            "attributes" => [
              { "name" => "title", "type" => "string", "default" => "Hello world" },
              { "name" => "body", "type" => "text" }
            ]
          }
        }

        subject(:validator) {
          Canvas::Validator::MenuSchema.new(schema: schema, custom_types: [card_type])
        }

        let(:schema) {
          {
            "attributes" => {
              "title" => {
                "type" => "string"
              },
              "cards" => {
                "type" => "Card",
                "array" => true
              }
            }
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when the `layout` is valid" do
        let(:schema) {
          {
            "attributes" => {
              "title" => {
                "type" => "string"
              },
              "images" => {
                "type" => "image",
                "label" => "Cool image"
              }
            },
            "layout" => [
              {
                "type" => "tab",
                "label" =>  "Design",
                "elements" => [
                  "title",
                  "images"
                ]
              }
            ]
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when 'layout' key is incorrect format" do
        let(:schema) {
          {
            "attributes" => {
              "title" => {
                "type" => "string"
              },
              "images" => {
                "type" => "image",
                "label" => "Cool image"
              }
            },
            "layout" => [
              {
                "label" => "Design",
                "type" => "unknown"
              }
            ]
          }
        }

        it "returns false with an error message" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            match("The property '#/layout/0' did not contain a required property of 'elements")
          )
        end
      end
    end
  end
end
