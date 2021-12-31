describe Canvas::Checks do
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

  describe "#register" do
    it "registers the class specified as a check" do
      Canvas::Checks.register(DummyCheck)
      expect(Canvas::Checks.registered).to include(DummyCheck)
    end

    it "is idempotent" do
      Canvas::Checks.register(DummyCheck)
      Canvas::Checks.register(DummyCheck)
      Canvas::Checks.register(DummyCheck)

      expect(Canvas::Checks.registered).to include(DummyCheck).once
    end
  end

  describe "#deregister_all!" do
    it "deregisters all registered checks" do
      Canvas::Checks.register(DummyCheck)
      Canvas::Checks.deregister_all!
      expect(Canvas::Checks.registered).to be_empty
    end
  end
end
