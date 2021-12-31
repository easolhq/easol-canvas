require "thor"
require 'cli/ui'

module Canvas
  class Cli < Thor
    desc "lint", "Prints a hello world message"
    def lint
      CLI::UI::StdoutRouter.enable
      Canvas::Lint.new.run
    end
  end
end
