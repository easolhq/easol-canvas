describe Canvas::Validator::Html do
  describe "#validate" do
    it "returns true if the html passed is valid xml" do
      html = "<p>This is valid html</p>"
      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end

    it "returns true if the html passed is valid liquid" do
      html = <<-EOF
        <p>This is valid {{ liquid }}</p>
        {% foreach item in items %}
          {% if item.position < 5 %}
            <p>{{ item }}</p>
          {% endif %}
        {% endforeach %}
      EOF
      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end

    it "returns false if the html passed is not valid xml" do
      html = "<p>This is not valid html<\r\n"
      expect(Canvas::Validator::Html.new(html).validate).to be_falsey
    end

    it "returns false if the html passed is valid liquid but invalid html" do
      html = <<-EOF
        <p>This is valid {{ liquid }}</p>
        <div>
          {% foreach item in items %}
            <p>{{ item }}</p>
          {% endforeach %}
        <
      EOF
      expect(Canvas::Validator::Html.new(html).validate).to be_falsey
    end

    it "parses using HTML5" do
      # footer is an HTML5 element
      html = <<-EOF
        <footer>Hello world</footer>
      EOF
      expect(Canvas::Validator::Html.new(html).validate).to be_truthy
    end
  end
end
