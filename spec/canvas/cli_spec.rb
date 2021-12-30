describe Canvas::Cli do
  subject(:cli) { Canvas::Cli.new }

  describe "lint" do
    it "calls the TemplateCheck" do
      expect_any_instance_of(Canvas::TemplateCheck).to receive(:run)
      subject.lint
    end
  end
end
