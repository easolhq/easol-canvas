# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute.new(attribute: attribute)
  }

  describe "VALIDATORS constants" do
    it "has a validator defined for every primitive type" do
      Canvas::Constants::PRIMITIVE_TYPES.each do |primitive_type|
        expect(described_class::VALIDATORS).to have_key(primitive_type)
      end
    end
  end

  describe "#validate" do
    context "when the attribute has only required keys" do
      let(:attribute) {
        {
          "name" => "title",
          "type" => "string"
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when the attribute has only required and optional keys" do
      let(:attribute) {
        {
          "name" => "titles",
          "type" => "string",
          "label" => "Main Titles",
          "default" => "My Heading",
          "array" => true
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end

      context "accepts 'label' as an optional key" do
        let(:attribute) {
          {
            "name" => "titles",
            "type" => "string",
            "label" => "My cool label"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "accepts 'hint' as an optional key" do
        let(:attribute) {
          {
            "name" => "titles",
            "type" => "string",
            "hint" => "An hint"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end

    context "when the attribute is missing 'type' key" do
      let(:attribute) {
        {
          "name" => "title"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "Missing required keys: type"
        )
      end
    end

    describe "validating an optional 'options' key" do
      context "when the attribute is a select type" do
        context "the 'options' key is not provided" do
          let(:attribute) {
            { "name" => "alignment", "type" => "select" }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "Missing required keys: options"
            )
          end
        end

        context "options is not an Array" do
          let(:attribute) {
            { "name" => "alignment", "type" => "select", "options" => "options" }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"options\" is a String, expected Array"
            )
          end
        end

        context "an empty 'options' is provided" do
          let(:attribute) {
            { "name" => "alignment", "type" => "select", "options" => [] }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "Must provide at least 1 option for select type variable"
            )
          end
        end

        context "not all options are a Hash" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", :"value" => "start" },
                "End"
              ]
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "All options for select type variable must specify a label and value"
            )
          end
        end

        context "not all options have a label" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", :"value" => "start" },
                { "value" => "end" }
              ]
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "All options for select type variable must specify a label and value"
            )
          end
        end

        context "not all options have a value" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", :"value" => "start" },
                { "label" => "Bottom" }
              ]
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "All options for select type variable must specify a label and value"
            )
          end
        end

        context "at least one option is provided in the correct format" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", "value" => "start" },
                { "label" => "Bottom", "value" => "end" }
              ]
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end
      end

      context "when the attribute is not a select type" do
        context "the 'options' key is provided" do
          let(:attribute) {
            {
              "name" => "titles",
              "type" => "string",
              "options" => [
                { "label" => "Top", "value" => "start" },
                { "label" => "Bottom", "value" => "end" }
              ]
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "Unrecognized keys: options"
            )
          end
        end
      end
    end

    describe "validating an optional 'default' key" do
      context "when the type is 'select'" do
        context "when 'default' is one of the select options" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", "value" => "start" },
                { "label" => "Bottom", "value" => "end" }
              ],
              "default" => "end"
            }
          }

          it "returns true" do
            expect(validator.validate).to eq(true)
          end
        end

        context "when 'default' isn't on the expected lower case" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", "value" => "start" },
                { "label" => "Bottom", "value" => "end" }
              ],
              "default" => "START"
            }
          }

          it "returns false" do
            expect(validator.validate).to eq(false)
          end
        end

        context "when 'default' isn't one of the select options" do
          let(:attribute) {
            {
              "name" => "alignment",
              "type" => "select",
              "options" => [
                { "label" => "Top", "value" => "start" },
                { "label" => "Bottom", "value" => "end" }
              ],
              "default" => "middle"
            }
          }

          it "returns false with errors" do
            expect(validator.validate).to eq(false)
            expect(validator.errors).to include(
              "\"default\" is 'middle', expected one of: start, end"
            )
          end
        end
      end
    end

    describe "validating an optional 'group' key" do
      context "when the 'group' is empty" do
        let(:attribute) {
          {
            "name" => "titles",
            "type" => "string",
            "group" => nil
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"group\" is '', expected one of: content, layout, design, mobile"
          )
        end
      end

      context "when the 'group' is an empty string" do
        let(:attribute) {
          {
            "name" => "titles",
            "type" => "string",
            "group" => ""
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"group\" is '', expected one of: content, layout, design, mobile"
          )
        end
      end

      context "when the 'group' is not set to a recognised value" do
        let(:attribute) {
          {
            "name" => "titles",
            "type" => "string",
            "group" => "another group"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"group\" is 'another group', expected one of: content, layout, design, mobile"
          )
        end
      end

      context "when the 'group' is an allowed one" do
        let(:attribute) {
          {
            "name" => "titles",
            "type" => "string",
            "group" => "design"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end

    context "when a reserved word is used for the 'name'" do
      let(:attribute) {
        {
          "name" => "page",
          "type" => "string"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "\"name\" can't be one of these reserved words: page, company, cart, flash, block"
        )
      end
    end

    context "when 'additional_reserved_names' are specified" do
      subject(:validator) {
        Canvas::Validator::SchemaAttribute.new(
          attribute: attribute,
          additional_reserved_names: %w[items]
        )
      }

      context "when an additional reserved word is used for the 'name'" do
        let(:attribute) {
          {
            "name" => "items",
            "type" => "string"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"name\" can't be one of these reserved words: page, company, cart, flash, block, items"
          )
        end
      end

      context "when a normal reserved word is used for the 'name'" do
        let(:attribute) {
          {
            "name" => "company",
            "type" => "string"
          }
        }

        it "returns false with errors" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"name\" can't be one of these reserved words: page, company, cart, flash, block, items"
          )
        end
      end

      context "when a non-reserved word is used for the 'name'" do
        let(:attribute) {
          {
            "name" => "my_title",
            "type" => "string"
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end
    end

    context "when attribute is using a custom type" do
      subject(:validator) {
        Canvas::Validator::SchemaAttribute.new(attribute: attribute, custom_types: [card_type])
      }

      let(:card_type) {
        {
          "key" => "Card",
          "name" => "Card",
          "attributes" => [
            { "name" => "title", "type" => "string", "default" => "Hello world" },
            { "name" => "body", "type" => "text" },
            { "name" => "alignment", "type" => "radio", "options" => [{ "label" => "Top", "value" => "top" }] }
          ]
        }
      }

      let(:attribute) {
        {
          "name" => "my_card",
          "type" => "Card"
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end

      context "when array is true and custom type includes nonarray supported types" do
        let(:attribute) {
          {
            "name" => "my_card",
            "type" => "Card",
            "array" => true
          }
        }

        it "return false" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "Cannot be an array because \"Card\" type includes nonarray types"
          )
        end
      end
    end

    context "when the type is not lowercase" do
      let(:attribute) {
        {
          "name" => "title",
          "type" => "String"
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when attribute is not a hash" do
      let(:attribute) { nil }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Must be valid JSON")
      end
    end

    context "when attribute has missing keys" do
      let(:attribute) {
        {
          "type" => "string",
          "default" => true,
          "array" => false
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Missing required keys: name")
      end
    end

    context "when name is not a string" do
      let(:attribute) {
        {
          "name" => true,
          "type" => "string"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"name\" is a TrueClass, expected String")
      end
    end

    context "when label is not a string" do
      let(:attribute) {
        {
          "name" => "title",
          "type" => "string",
          "label" => false
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"label\" is a FalseClass, expected String")
      end
    end

    context "when array is not a boolean" do
      let(:attribute) {
        {
          "name" => "title",
          "type" => "string",
          "array" => "hello"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"array\" is 'hello', expected one of: true, false")
      end
    end

    context "when name is a reserved name" do
      let(:attribute) {
        {
          "name" => "cart",
          "type" => "string"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("\"name\" can't be one of these reserved words: #{described_class::RESERVED_NAMES.join(", ")}")
      end
    end

    context "when type is not a valid primitive" do
      let(:attribute) {
        {
          "name" => "title",
          "type" => "unknown"
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include(
          "\"type\" must be one of: #{Canvas::Constants::PRIMITIVE_TYPES.join(", ")}"
        )
      end
    end

    context "when type is boolean and array is true" do
      let(:attribute) {
        {
          "name" => "show_cta",
          "type" => "boolean",
          "array" => true
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Boolean attributes cannot be arrays")
      end
    end

    context "when type is radio and array is true" do
      let(:attribute) {
        {
          "name" => "show_cta",
          "type" => "radio",
          "array" => true,
          "options" => [{label: "Top", value: "top"}]
        }
      }

      it "returns false with errors" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to include("Radio attributes cannot be arrays")
      end
    end
  end
end
