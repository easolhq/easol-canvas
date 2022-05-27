require "thor"
require 'cli/ui'

module Canvas
  class Cli < Thor
    desc "lint", "Prints a hello world message"
    def lint
      CLI::UI::StdoutRouter.enable
      Canvas::Lint.new.run
    end

    map %w[--version -v] => :__print_version
    desc "--version, -v", "print the version"
    def __print_version
      puts Canvas::VERSION
    end
  end
end
