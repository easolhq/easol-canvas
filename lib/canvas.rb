require_relative "canvas/version"
require_relative "canvas/constants"
require_relative "canvas/cli"
require_relative "canvas/lint"
require_relative "canvas/check"
require_relative "canvas/offense"
require_relative "canvas/checks"

files = Dir["#{__dir__}/canvas/{checks,services,validators}/*.rb"]
files.each { |file| require file }

Canvas::Checks.register(Canvas::RequiredFilesCheck)
Canvas::Checks.register(Canvas::ValidHtmlCheck)
Canvas::Checks.register(Canvas::ValidLiquidCheck)

module Canvas
end
