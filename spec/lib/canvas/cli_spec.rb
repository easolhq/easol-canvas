describe Canvas::Cli do
  subject(:cli) { Canvas::Cli.new }

  describe "lint" do
    it "calls the Lint object" do
      expect_any_instance_of(Canvas::Lint).to receive(:run)
      subject.lint
    end
  end
end
