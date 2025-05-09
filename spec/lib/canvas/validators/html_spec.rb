# frozen_string_literal: true

describe Canvas::Validator::Html do
  describe "#validate" do
    it "returns true if the html passed is valid xml" do
      html = "<p>This is valid html</p>"
      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end

    it "returns false if the html passed is not valid xml" do
      html = "<p>This is not valid html<\r\n"
      expect(Canvas::Validator::Html.new(html).validate).to be_falsey
    end

    it "returns false if the html passed is valid liquid but invalid html" do
      html = <<-LIQUID
        <p>This is valid {{ liquid }}</p>
        <div>
          {% for item in items %}
            <p>{{ item }}</p>
          {% endfor %}
        <
      LIQUID
      expect(Canvas::Validator::Html.new(html).validate).to be_falsey
    end

    it "parses using HTML5" do
      # footer is an HTML5 element
      html = <<-LIQUID
        <footer>Hello world</footer>
      LIQUID
      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end

    it "strips out front matter" do
      html = <<-LIQUID
        ---
        form_snippet:
          type: string
          hint: Configure a form with a third-party. Codes begin with `<frame>` or `<script>`.
        ---
        <p>This is valid html</p>
      LIQUID

      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end

    it "strips out liquid" do
      html = <<-LIQUID
        <{{ tag | default: 'div' }}>This is valid html</{{ tag | default: 'div' }}>
      LIQUID

      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end
  end

  describe "#strip_out_liquid" do
    it "handles liquid tags and variables differently" do
      html = <<~LIQUID
        <a href="{{ variable }}" {% if condition %}target="_blank"{% endif %}>Link</a>
      LIQUID
      validator = described_class.new(html)
      stripped = validator.send(:strip_out_liquid, html).chomp
      expect(stripped).to eq(
        '<a href="xxxxxxxxxxxxxx"                   target="_blank"           >Link</a>'
      )
    end

    it "validates html with liquid tags and variables" do
      html = <<~LIQUID
        <div class="{% if condition %}active{% endif %}">
          <h1>{{ title }}</h1>
          <p>{{ content }}</p>
        </div>
      LIQUID

      validator = described_class.new(html)
      expect(validator.validate).to be_truthy
    end
  end
end
