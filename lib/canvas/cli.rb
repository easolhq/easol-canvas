require "thor"

module Canvas
  class Cli < Thor
    desc "hello_world", "Prints a hello world message"
    def hello_world
      puts "Hello World!"
    end
  end
end
