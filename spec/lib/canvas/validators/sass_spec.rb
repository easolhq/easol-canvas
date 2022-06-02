
# frozen_string_literal: true

describe Canvas::Validator::Sass do
  describe "#validate" do
    it "returns true if it is valid sass" do
      sass = <<-EOS
        .block {
          padding-top: 0;
          padding-bottom: 0;
        }
        .block-content {
          max-width: none;
          padding: 0;
        }
      EOS
      expect(Canvas::Validator::Sass.new(sass).validate).to eq(true)
    end

    it "returns false if is invalid json" do
      sass = <<-EOS
        .block {
          padding-top: 0;
          padding-bottom: 0;

        .block-content {
          max-width: none;
          padding: 0;
        }
      EOS
      expect(Canvas::Validator::Sass.new(sass).validate).to eq(false)
    end
  end
end
