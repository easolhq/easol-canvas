# frozen_string_literal: true

describe Canvas::FrontMatterExtractor do
  subject(:service) {
    Canvas::FrontMatterExtractor.new(markup)
  }

  let(:markup) {
    <<~EOS
      ---
      some_variable:
        type: string
        default: Some text
      ---
      <h1>Header text</h1>
      <p class='paragraph-class'>Some paragraph content</p>
    EOS
  }

  describe "#front_matter" do
    context "when markup includes front matter" do
      it "returns just the front matter with the html stripped out" do
        json = YAML.safe_load(service.front_matter)
        expect(json).to eq(
          "some_variable" => {
            "type" => "string",
            "default" => "Some text"
          }
        )
      end
    end

    context "when markup does not include front matter" do
      let(:markup) {
        <<~EOS
          <h1>Header text</h1>
          <p class='paragraph-class'>Some paragraph content</p>
        EOS
      }

      it "returns nil" do
        expect(service.front_matter).to eq(nil)
      end
    end

    context "when markup includes only front matter" do
      let(:markup) {
        <<~EOS
        ---
        some_variable:
          type: string
          default: Some text
        ---
        EOS
      }

      it "returns nil" do
        expect(service.front_matter).to eq(nil)
      end
    end
  end

  describe "#html" do
    context "when markup includes front matter" do
      it "returns just the html with the front matter stripped out" do
        expect(service.html).not_to include("---")
        expect(service.html).to include("<h1>Header text</h1>")
        expect(service.html).to include("<p class='paragraph-class'>Some paragraph content</p>")
      end
    end

    context "when markup does not include front matter" do
      let(:markup) {
        <<~EOS
          <h1>Header text</h1>
          <p class='paragraph-class'>Some paragraph content</p>
        EOS
      }

      it "returns just the html" do
        expect(service.html).not_to include("---")
        expect(service.html).to include("<h1>Header text</h1>")
        expect(service.html).to include("<p class='paragraph-class'>Some paragraph content</p>")
      end
    end

    context "when markup includes only front matter" do
      let(:markup) {
        <<~EOS
        ---
        some_variable:
          type: string
          default: Some text
        ---
        EOS
      }

      it "returns empty string" do
        expect(service.html).to eq("")
      end
    end
  end
end
