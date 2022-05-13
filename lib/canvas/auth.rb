require "fileutils"
require "netrc"
require_relative "auth/server"

module Canvas
  class Auth
    NETRC_MACHINE_URL = "myeasol.com"
    AUTHORIZARTION_URL = "#{NETRC_MACHINE_URL}/authorize"

    def login
      check_for_netrc_file
      begin_auth_server
      @auth_server_thread.join
      write_credentials
    end

    private

    def begin_auth_server
      @auth_server_thread = Thread.new { server.start }
    end

    def write_credentials
      credentials = @auth_server_thread.value
      netrc[NETRC_MACHINE_URL] = credentials[0], credentials[1]
      netrc.save
    end

    def server
      Canvas::Auth::Server.new
    end

    def check_for_netrc_file
      unless File.exists? netrc_location
        create_netrc_file
      end
    end

    def create_netrc_file
      FileUtils.touch(netrc_location)
      FileUtils.chmod(0600, netrc_location)
    end
    
    def netrc_location
      File.join(ENV['NETRC_LOCATION'] || Dir.home, Netrc.netrc_filename)
    end

    def netrc
      @_netrc ||= Netrc.read(netrc_location)
    end
  end
end
