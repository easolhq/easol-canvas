# frozen_string_literal: true

require "cli/ui"

module Canvas
  #:documented:
  class Login
    def run
      api_key = CLI::UI.ask("What's your Easol API Key?")

      Canvas::GlobalConfig.set(api_key: api_key)
    end
  end
end
