describe Canvas::Auth do
  let(:auth) { Canvas::Auth.new }
  let(:server_mock) { double(:server, start: credentials) }
  let(:credentials) {
    {
      email: "kyle@easol.com", 
      token: "12345" 
    }
  }

  before do
    stub_const('ENV', ENV.to_hash.merge('NETRC_LOCATION' => '.'))
    allow(auth).to receive(:server).and_return(server_mock)
  end

  describe "#login" do
    it "creates a .netrc file if missing" do
      expect(File.exist?(".netrc")).to be false

      auth.login

      expect(File.exist?(".netrc")).to be true
    end

    it "starts an authorization server" do
      auth.login
      expect(server_mock).to have_received(:start)
    end

    it "persists the credentials to the netrc file" do
      auth.login

      email, token = Netrc.read("./.netrc")[Canvas::Auth::NETRC_MACHINE_URL]
      expect(email).to eq "kyle@easol.com"
      expect(token).to eq "12345"
    end
  end
end
