require "thor"

module Canvas
  class Cli < Thor
    desc "lint", "Prints a hello world message"
    def lint
      Canvas::Lint.new.run
    end
  end
end
