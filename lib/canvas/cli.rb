require "thor"

module Canvas
  class Cli < Thor
    desc "hello_world", "Prints a hello world message"
    def list
      dir = Dir.getwd
      puts Dir.new(dir).each.to_a
    end
  end
end
