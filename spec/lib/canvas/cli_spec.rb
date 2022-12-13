# frozen_string_literal: true

describe Canvas::Cli do
  subject(:cli) { Canvas::Cli.new }

  describe "lint" do
    it "calls the Lint object" do
      expect_any_instance_of(Canvas::Lint).to receive(:run)
      subject.lint
    end
  end

  describe "__print_version" do
    it "prints the gem version" do
      stdout, _err = capture_io { subject.__print_version }
      expect(stdout).to eq(Canvas::VERSION + "\n")
    end
  end
end
