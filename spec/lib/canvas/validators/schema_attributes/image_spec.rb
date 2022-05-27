# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Image do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Image.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      let(:default) { "https://my-image.jpg" }
      let(:attribute) {
        {
          "name" => "my_image",
          "type" => "image",
          "default" => default
        }
      }

      context "when default is string" do
        it { expect(validator.validate).to eq(true) }
      end

      context "when default is asset" do
        let(:default) {
          {
            "asset" => "assets/images//my-image.jpg"
          }
        }

        it { expect(validator.validate).to eq(true) }
      end

      context "when default is url" do
        let(:default) {
          {
            "url" => "https://repo.com/assets/images//my-image.jpg"
          }
        }

        it { expect(validator.validate).to eq(true) }
      end

      context "when multiple defaults are provided" do
        let(:default) {
          {
            "asset" => "assets/image.jpg",
            "url" => "http://easol.test/assets/image.jpg"
          }
        }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for image-type variables must include a single url or asset value"
          )
        end
      end

      context "when \"url\" default is provided but is not a string" do
        let(:default) {
          {
            "url" => { "invalid" => "option" }
          }
        }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for image-type variables must include a single url or asset value"
          )
        end
      end

      context "when \"asset\" default is provided but is not a string" do
        let(:default) {
          {
            "asset" => { "invalid" => "option" }
          }
        }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for image-type variables must include a single url or asset value"
          )
        end
      end

      context "when unknown default is provided" do
        let(:default) { { "unknown" => "LMAO" } }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for image-type variables must include a single url or asset value"
          )
        end
      end

      context "when an empty default is set" do
        let(:default) { Hash[] }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for image-type variables must include a single url or asset value"
          )
        end
      end

      context "when no default key is included" do
        let(:attribute) {
          {
            "name" => "my_image",
            "type" => "image"
          }
        }

        it "is valid" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when default is an array of valid options" do
        let(:attribute) {
          {
            "name" => "my_image",
            "type" => "image",
            "array" => true,
            "default" => [
              "https://repo.com/my-image.jpg",
              { "url" => "https://repo.com/my-image.jpg" },
              { "asset" => "images/my-image.jpg" }
            ]
          }
        }

        it "returns true" do
          expect(validator.validate).to eq(true)
        end
      end

      context "when default is an array with invalid options" do
        let(:attribute) {
          {
            "name" => "my_image",
            "type" => "image",
            "array" => true,
            "default" => [
              "https://repo.com/my-image.jpg",
              {
                "url" => { "invalid" => "option" }
              }
            ]
          }
        }

        it "adds an error and fails the validation" do
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for image-type variables must include a single url or asset value"
          )
        end
      end
    end
  end
end
