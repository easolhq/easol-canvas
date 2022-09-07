# frozen_string_literal: true

require "open3"

module Canvas
  # This is a thin wrapper around the dartsass binary as provided by
  # dartsass-rails.
  #
  # It is compatible with SassC::Engine as much as we were using it, but 100%
  # compatability is not a goal.
  class DartSass
    Error = Class.new(StandardError)

    def initialize(css, config)
      @css = css
      @config = config
    end

    def render
      stdout, stderr, status = Open3.capture3(*command, stdin_data: @css)

      if status == 0
        stdout
      else
        raise Error.new(stderr)
      end
    end

    private

    def command
      [dartsass, "--stdin", style, *load_paths].compact
    end

    def dartsass
      Gem.bin_path("dartsass-rails", "dartsass").shellescape
    end

    def style
      (s = @config[:style]) && "--style=#{s.to_s.shellescape}"
    end

    def load_paths
      Array(@config[:load_paths]).map { "--load-path=#{_1.shellescape}" }
    end
  end
end
