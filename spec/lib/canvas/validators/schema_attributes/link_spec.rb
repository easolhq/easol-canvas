# frozen_string_literal: true

describe Canvas::Validator::SchemaAttribute::Link do
  subject(:validator) {
    Canvas::Validator::SchemaAttribute::Link.new(attribute)
  }

  describe "#validate" do
    describe "validating an optional 'default' key" do
      let(:default) { { "url" => "https://easol.test" } }
      let!(:attribute) {
        {
          "name" => "my_link",
          "type" => "link",
          "default" => default
        }
      }

      context "default is url" do
        let(:default) { { "url" => "https://easol.test" } }
        it { expect(validator.validate).to eq(true) }
      end

      context "default is page" do
        let(:default) { { "page" => "page_id" } }
        it { expect(validator.validate).to eq(true) }
      end

      context "default is blog post" do
        let(:default) { { "post" => "post_id" } }
        it { expect(validator.validate).to eq(true) }
      end

      context "default is product" do
        let(:default) { { "product" => "sgid_param" } }
        it { expect(validator.validate).to eq(true) }
      end

      context "when multiple defaults are provided" do
        let(:default) { { "product" => "sgid_param", "url" => "easol.test" } }
        it {
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for link-type variables must include a single url, page, post or product value"
          )
        }
      end

      context "when unknown default is provided" do
        let(:default) { { "unknown" => "LMAO" } }
        it {
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for link-type variables must include a single url, page, post or product value"
          )
        }
      end

      context "when no default is provided" do
        let(:default) { Hash[] }
        it {
          expect(validator.validate).to eq(false)
          expect(validator.errors).to include(
            "\"default\" for link-type variables must include a single url, page, post or product value"
          )
        }
      end
    end
  end
end
