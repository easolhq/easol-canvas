describe Canvas::Lint do
  subject(:linter) { Canvas::Lint.new }

  before do
    stub_const(
      "DummyCheck",
      Class.new(Canvas::Check)
    )

    @registered_checks = Canvas::Checks.registered
    Canvas::Checks.deregister_all!
  end

  after do
    @registered_checks.each do |check|
      Canvas::Checks.register(check)
    end
  end

  describe "#run" do
    it "runs all registered checks" do
      Canvas::Checks.register(DummyCheck)
      expect_any_instance_of(DummyCheck).to receive(:run)

      stdout, _err = capture_io { linter.run }

      expect(stdout).to include("DummyCheck")
    end

    it "outputs a failure message if any checks fail" do
      Canvas::Checks.register(DummyCheck)
      allow_any_instance_of(DummyCheck).to receive(:failed?).and_return(true)

      stdout, _err = capture_io { linter.run }

      expect(stdout).to include("Failures!")
    end
  end
end
