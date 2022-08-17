# frozen_string_literal: true

describe Canvas::Validator::LayoutSchema do
  subject(:validator) {
    Canvas::Validator::LayoutSchema.new(schema: schema)
  }

  let(:attributes) do
    {
      "attributes" => {
        "description" => {
          "type" => "string"
        },
        "Heading" => {
          "type" => "string"
        },
        "logo_alt" => {
          "type" => "string"
        },
        "title" => {
          "type" => "string"
        },
        "show_title" => {
          "type" => "boolean"
        },
        "SHOUT" => {
          "type" => "Boolean"
        }
      }
    }
  end

  describe "on schema format validation" do
    describe "when layout is empty" do
      let(:schema) do
        {
          **attributes,
        }
      end

      it "returns true" do
        expect(validator.validate).to be_truthy
      end
    end

    describe "when format is valid" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                {
                  "type" => "accordion",
                  "label" => "Logo",
                  "elements" => [
                    "description",
                    { "type" => "attribute", "name" => "Logo_alt" },
                    "title"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns true" do
        expect(validator.validate).to be_truthy
      end
    end

    describe "when first level element type isn't tab" do
      let(:schema) do
        {
          "layout" => [
            {
              "label" => "Design",
              "type" => "attribute",
              "elements" => [
                "description"
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include(match("The property '#/layout/0/type' value \"attribute\" did not match constant 'tab' in schema"))
      end
    end

    describe "when multiple tabs have the same label" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => ["description"]
            },
            {
              "label" => "Content",
              "type" => "tab",
              "elements" => ["logo_alt"]
            },
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => ["show_title"]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include(match("Duplicated tab label `Design` found. Location: layout/0, layout/2"))
      end
    end

    describe "when first level element hasn't children" do
      let(:schema) do
        {
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => []
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include(match("The property '#/layout/0/elements' did not contain a minimum number of items 1 in schema"))
      end
    end

    describe "when first level elementtype isn't tab" do
      let(:schema) do
        {
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "description",
                1234,
                {
                  "type" => "accordion",
                  "label" => "Logo",
                  "elements" => [
                    "logo",
                    "logo_alt",
                    { "name" => "caption", "type" => "unknown" }
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end


      it "contains errors" do
        validator.validate

        expect(validator.errors).to include(match("The property '#/layout/0/elements/1' of type integer did not match any of the required schemas."))
        expect(validator.errors).to include(match("The property '#/layout/0/elements/2' of type object did not match any of the required schemas"))
      end
    end

    context "when layout includes accordion_toggle" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "show_title",
                  "elements" => [
                    "title",
                    "description"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns true" do
        expect(validator.validate).to be_truthy
      end
    end

    context "when layout includes accordion_toggle with invalid format" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                {
                  "type" => "accordion_toggle",
                  "elements" => [
                    "title",
                    "description"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end


      it "contains errors" do
        validator.validate

        expect(validator.errors).to include(match("The property '#/layout/0/elements/1' of type object did not match any of the required schemas."))
      end
    end
  end

  describe "on business rule validation" do
    describe "when duplicated attribute keys are present" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "description",
                "heading",
                {
                  "type" => "accordion",
                  "label" => "Logo",
                  "elements" => [
                    "description",
                    { "type" => "attribute", "name" => "logo_alt" },
                    "title"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include("Duplicated attribute key `description` found. Location: layout/0/elements/0, layout/0/elements/2/elements/0")
      end
    end

    describe "when unrecognized attribute keys are present" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                "unknown",
                {
                  "type" => "accordion",
                  "label" => "Logo",
                  "elements" => [
                    "description",
                    { "type" => "attribute", "name" => "logo_alt" },
                    "title"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include("Unrecognized attribute `unknown`. Location: layout/0/elements/1")
      end
    end

    context "when accordion_toggle has a toggle_attribute that is unrecognized" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "unknown",
                  "elements" => [
                    "title",
                    "description"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include("The toggle_attribute in accordion_toggle is unrecognized. Location: layout/0/elements/1")
      end
    end

    context "when accordion_toggle has a toggle_attribute that is not a boolean" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "description",
                  "elements" => [
                    "title",
                    "description"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate

        expect(validator.errors).to include("The toggle_attribute in accordion_toggle must be a boolean. Location: layout/0/elements/1")
      end
    end

    context "when accordion_toggle has a toggle_attribute that is Boolean defined with a capital letter" do
      let(:schema) do
        {
          **attributes,
          "layout" => [
            {
              "label" => "Design",
              "type" => "tab",
              "elements" => [
                "heading",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "SHOUT",
                  "elements" => [
                    "title",
                    "SHOUT"
                  ]
                }
              ]
            }
          ]
        }
      end

      it "is valid" do
        expect(validator.validate).to be_truthy
      end
    end
  end
end
