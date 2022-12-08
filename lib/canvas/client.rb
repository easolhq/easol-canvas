require "net/http"

module Canvas
  class Client
    ENDPOINT_BASE = "http://%s.easol.test"
    class RequestError < StandardError; end
    class ServerError < StandardError; end
    class UnhandledResponseError < StandardError; end

    def initialize
      @endpoint_base = ENDPOINT_BASE
      @api_key = Canvas::GlobalConfig.get(:api_key)
    end

    def get(path, **opts)
      uri = URI.parse(endpoint_base % opts.fetch(:subdomain) + path)
      http = prepare_http(uri)

      handle_response http.get(
        uri,
        request_headers.merge(opts.fetch(:headers, {}))
      )
    end

    def post(path, **opts)
      uri = URI.parse(endpoint_base % opts.fetch(:subdomain) + path)
      http = prepare_http(uri)

      handle_response http.post(
        uri,
        opts.fetch(:body, {}).to_json,
        request_headers.merge(opts.fetch(:headers, {}))
      )
    end

    def delete(path, **opts)
      uri = URI.parse(endpoint_base % opts.fetch(:subdomain) + path)
      http = prepare_http(uri)

      request = Net::HTTP::Delete.new(
        uri.path,
        request_headers.merge(opts.fetch(:headers, {}))
      )
      request.body = opts.fetch(:body, {}).to_json

      handle_response http.request(request)
    end

    private

    attr_reader :debug_mode, :endpoint_base

    def prepare_http(uri)
      Net::HTTP.new(uri.host, uri.port)
    end

    def request_headers
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@api_key}"
      }
    end

    def handle_response(response)
      case response.code.to_i
      when 400, 401, 403, 404, 409, 422
        raise RequestError.new(response.body)
      when 500
        raise ServerError.new(response.body)
      when 200, 201, 202
        JSON.parse(response.body)
      else
        raise UnhandledResponseError.new(response.body)
      end
    rescue JSON::ParserError
    end
  end
end
