# frozen_string_literal: true

require "thor"
require "cli/ui"

module Canvas
  # :documented:
  class Cli < Thor
    desc "lint", "Prints a hello world message"
    def lint(*files)
      CLI::UI::StdoutRouter.enable
      Canvas::Lint.new.run(files)
    end

    map %w[--version -v] => :__print_version
    desc "--version, -v", "print the version"
    def __print_version
      puts Canvas::VERSION
    end

    desc "dev", "Starts a dev server"
    def dev
      Canvas::DevServer.new.run
    end

    desc "login", "Authorise with your Easol Account"
    def login
      Canvas::Login.new.run
    end
  end
end
