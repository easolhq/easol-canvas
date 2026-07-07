# frozen_string_literal: true

require "sass-embedded"

module Canvas
  # Compiles SCSS with dart-sass via the sass-embedded Ruby API.
  #
  # It is compatible with SassC::Engine as much as we were using it, but 100%
  # compatability is not a goal.
  #
  # We use the in-process API rather than shelling out to the `dartsass`
  # executable: the CLI resolves `Gem.bin_path("sass-embedded", "sass")`, which
  # is ambiguous (and noisy on stderr) whenever another bundled gem — e.g. the
  # legacy `sass` gem — also ships a `sass` executable. The API has no such
  # dependency on executable resolution and avoids a subprocess per render.
  class DartSass
    Error = Class.new(StandardError)

    def initialize(css, config)
      @css = css
      @config = config
    end

    def render
      Sass.compile_string(
        @css,
        load_paths: Array(@config[:load_paths]),
        style: @config[:style] || :expanded
      ).css
    rescue Sass::CompileError => e
      # detailed_message keeps the formatted dart-sass error (source snippet and
      # line:column) the CLI used to print to stderr; highlight: false strips ANSI.
      raise Error.new(e.detailed_message(highlight: false))
    end
  end
end
