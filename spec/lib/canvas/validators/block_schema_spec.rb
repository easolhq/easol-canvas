describe Canvas::Validator::BlockSchema do
  describe "#validate" do
    subject(:validator) {
      Canvas::Validator::BlockSchema.new(schema: schema)
    }

    context "when schema is valid" do
      let(:schema) {
        {
          "attributes" => [
            {
              "name" => "my_title",
              "type" => "string"
            },
            {
              "name" => "my_color",
              "type" => "color",
              "label" => "My Color",
              "hint" => "Pick you favourite color",
              "default" => { "r" => 255, "g" => 255, "b" => 255 }
            }
          ]
        }
      }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when schema contains unrecognized keys" do
      let(:schema) {
        {
          "attributes" => [
            {
              "name" => "my_title",
              "type" => "string"
            }
          ],
          "unknown" => "Hello World"
        }
      }

      it "returns false with an error message" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to eq(
          [
            "Unrecognized keys: unknown"
          ]
        )
      end
    end

    context "when 'attributes' key is missing" do
      let(:schema) { {} }

      it "returns true" do
        expect(validator.validate).to eq(true)
      end
    end

    context "when 'attributes' key is incorrect format" do
      let(:schema) {
        {
          "attributes" => ["an attribute"]
        }
      }

      it "returns false with an error message" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to eq(
          [
            "Schema is not in a valid format"
          ]
        )
      end
    end

    context "when an attribute is invalid" do
      let(:schema) {
        {
          "attributes" => [
            {
              "name" => "my_title",
              "type" => "string",
              "unknown" => "hello"
            }
          ]
        }
      }

      it "returns false with an error message" do
        expect(validator.validate).to eq(false)
        expect(validator.errors).to eq(
          [
            "Attribute \"my_title\" is invalid - Unrecognized keys: unknown"
          ]
        )
      end
    end
  end
end
