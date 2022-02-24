describe Canvas::DevServer do
  include ExampleDirectoryHelper

  describe "Watching linked files for modification" do
    it "calls the observed methods when a linked file changes" do
      copy_example_directory("alchemist")

      Canvas::Linker.new.link("blocks/hero/block.liquid", 12345)

      start_server
      sleep(0.5) # Wait for server to start

      File.write("blocks/hero/block.liquid", "a") {}

      with_retries do
        expect(Canvas::Config.get(:synced)).to eq true
      end
    ensure
      @server_thread.kill
    end

    def start_server
      @server_thread = Thread.new do
        @server = Canvas::DevServer.new.run
      rescue => e
        puts "Failed to start dev server"
        puts e.message
      end
    end

    def with_retries(retries: 5)
      yield
    rescue RSpec::Expectations::ExpectationNotMetError
      retries -= 1
      if retries > 0
        sleep(0.5)
        retry
      else
        raise
      end
    end
  end
end
