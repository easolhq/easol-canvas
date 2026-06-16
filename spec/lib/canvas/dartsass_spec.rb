# frozen_string_literal: true

describe Canvas::DartSass do
  describe "#render" do
    it "compiles SCSS to CSS" do
      result = described_class.new("a { b { color: red; } }", {}).render

      expect(result).to include("a b")
      expect(result).to include("color: red")
    end

    it "honours the compressed style" do
      result = described_class.new("a { color: red; }", { style: :compressed }).render

      expect(result).not_to include("\n")
    end

    it "resolves imports from the configured load paths" do
      Dir.mkdir("partials")
      File.write("partials/_vars.scss", "$c: blue;")

      result = described_class.new(
        %(@import "vars"; a { color: $c; }),
        { load_paths: ["partials"] }
      ).render

      expect(result).to include("color: blue")
    end

    it "wraps a compiler failure in Canvas::DartSass::Error" do
      expect { described_class.new("a { color: red", {}).render }
        .to raise_error(Canvas::DartSass::Error)
    end
  end
end
