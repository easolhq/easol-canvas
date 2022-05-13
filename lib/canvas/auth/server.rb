require "socket"
require "uri"
require "cgi"

module Canvas
  class Auth
    class Server
      def start
        server = TCPServer.new 9876
        while connection = server.accept
          request = connection.gets
          data = handle(request)
          connection.puts 'OAuth request received. You can close this window now.'
          connection.close
          return data if data
        end
      end

      private

      def handle(request)
        _, full_path = request.split(' ')
        path = URI(full_path).path

        handle_authorization(full_path) if path == '/authorize'
      end

      def handle_authorization(full_path)
        params = CGI.parse(URI.parse(full_path).query)

        [params["email"], params["token"]].flatten
      end
    end
  end
end
