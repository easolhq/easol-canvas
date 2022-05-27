# frozen_string_literal: true

describe Canvas::Validator::Liquid do
  describe "#validate" do
    it "returns true if it is valid liquid" do
      liquid = <<-LIQUID
        <p>This is valid {{ liquid }}</p>
        {% for item in items %}
          {% if item.position < 5 %}
            <p>{{ item }}</p>
          {% endif %}
        {% endfor %}
      LIQUID
      expect(Canvas::Validator::Liquid.new(liquid).validate).to be_truthy
    end

    it "returns false if is invalid liquid" do
      html = "<p>{% if true %} This is not valid html</p>"
      expect(Canvas::Validator::Liquid.new(html).validate).to be_falsey
    end

    it "returns true if the liquid is valid but the it is invalid html" do
      html = "<p>{% if true %}This is not valid html {% endif %}<\r\n"
      expect(Canvas::Validator::Liquid.new(html).validate).to be_truthy
    end

    it "returns true if the liquid is using custom tags and is valid" do
      ::Liquid::Template.register_tag("form", ::Liquid::Block)
      html = "<div>{% form 'my_form' %} This is a form {% endform %}</div>"
      expect(Canvas::Validator::Liquid.new(html).validate).to be_truthy
    end

    it "strips out front matter" do
      html = <<-LIQUID
        ---
        form_snippet:
          type: string
          hint: This is some liquid to ignore {% if true %}
        ---
        <p>This is valid html</p>
      LIQUID

      expect(Canvas::Validator::Liquid.new(html).validate).to be_truthy
    end
  end
end
