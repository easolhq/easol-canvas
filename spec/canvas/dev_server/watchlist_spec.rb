describe Canvas::DevServer::Watcher do
  describe "#start" do
    it "begins a listener on the files specified by the watchlist" do
      watchlist_double = double(:watchlist, files: ["foo.txt", "bar.liquid"])
      listen_double = double(:listener)

      allow(Listen).to receive(:to).and_return(listen_double)
      allow(listen_double).to receive(:start)

      watcher = Canvas::DevServer::Watcher.new(watchlist_double)
      watcher.start

      expect(listen_double).to have_received(:start)
      expect(Listen).to have_received(:to).with(Dir.getwd, only: /foo.txt$|bar.liquid$/)
    end
  end
end
