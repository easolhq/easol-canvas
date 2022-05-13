require "thor"
require 'cli/ui'

module Canvas
  class Cli < Thor
    desc "lint", "Prints a hello world message"
    def lint
      CLI::UI::StdoutRouter.enable
      Canvas::Lint.new.run
    end

    desc "dev", "Starts a dev server"
    def dev
      Canvas::DevServer.new.run
    end

    desc "login", "Login with your Easol account"
    def login
      Canvas::Auth.new.login
    end
  end
end
