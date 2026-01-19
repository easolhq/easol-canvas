# frozen_string_literal: true

describe Canvas::Validator::CustomTypeLayoutSchema do
  subject(:validator) {
    Canvas::Validator::CustomTypeLayoutSchema.new(schema:)
  }

  let(:attributes) do
    [
      { "name" => "question", "type" => "string" },
      { "name" => "answer", "type" => "text" },
      { "name" => "show_icon", "type" => "boolean" },
      { "name" => "icon_color", "type" => "color" }
    ]
  end

  describe "on schema format validation" do
    describe "when layout is empty" do
      let(:schema) do
        { "attributes" => attributes }
      end

      it "returns true" do
        expect(validator.validate).to be_truthy
      end
    end

    describe "when format is valid with simple elements" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => %w[question answer]
            }
          ]
        }
      end

      it "returns true" do
        expect(validator.validate).to be_truthy
      end
    end

    describe "when format is valid with multiple groups" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            { "elements" => ["question"] },
            { "elements" => ["answer", "show_icon"] }
          ]
        }
      end

      it "returns true" do
        expect(validator.validate).to be_truthy
      end
    end

    describe "when format is valid with accordion" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                {
                  "type" => "accordion",
                  "label" => "Advanced",
                  "elements" => [
                    "answer",
                    { "type" => "attribute", "name" => "show_icon" }
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

    describe "when format is valid with accordion_toggle" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "show_icon",
                  "elements" => [
                    "icon_color"
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

    describe "when group is missing elements key" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            { "label" => "Content" }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate
        expect(validator.errors).to include(match("did not contain a required property of 'elements'"))
      end
    end

    describe "when elements array is empty" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            { "elements" => [] }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate
        expect(validator.errors).to include(match("did not contain a minimum number of items 1"))
      end
    end

    describe "when element has invalid type" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                1234,
                "question"
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
        expect(validator.errors).to include(match("did not match any of the required schemas"))
      end
    end

    describe "when accordion_toggle is missing toggle_attribute" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                {
                  "type" => "accordion_toggle",
                  "elements" => ["question"]
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
        expect(validator.errors).to include(match("did not match any of the required schemas"))
      end
    end

    describe "when group has unrecognized keys" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => ["question"],
              "unknown_key" => "value"
            }
          ]
        }
      end

      it "returns false" do
        expect(validator.validate).to be_falsey
      end

      it "contains errors" do
        validator.validate
        expect(validator.errors).to include(match("contains additional properties"))
      end
    end
  end

  describe "on business rule validation" do
    describe "when duplicated attribute keys are present" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                {
                  "type" => "accordion",
                  "label" => "Details",
                  "elements" => [
                    "question",
                    "answer"
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
        expect(validator.errors).to include(match("Duplicated attribute key `question` found"))
      end
    end

    describe "when unrecognized attribute keys are present" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                "unknown_attribute"
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
        expect(validator.errors).to include("Unrecognized attribute `unknown_attribute`. Location: layout/0/elements/1")
      end
    end

    describe "when accordion_toggle has unrecognized toggle_attribute" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "unknown",
                  "elements" => ["answer"]
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

    describe "when accordion_toggle has non-boolean toggle_attribute" do
      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "question",
                  "elements" => ["answer"]
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

    describe "when accordion_toggle has boolean toggle_attribute with capital letter type" do
      let(:attributes) do
        [
          { "name" => "question", "type" => "string" },
          { "name" => "answer", "type" => "text" },
          { "name" => "ENABLED", "type" => "Boolean" }
        ]
      end

      let(:schema) do
        {
          "attributes" => attributes,
          "layout" => [
            {
              "elements" => [
                "question",
                {
                  "type" => "accordion_toggle",
                  "toggle_attribute" => "ENABLED",
                  "elements" => ["answer"]
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
