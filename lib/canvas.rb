require_relative "canvas/version"
require_relative "canvas/cli"
require_relative "canvas/lint"
require_relative "canvas/validators/html"
require_relative "canvas/check"
require_relative "canvas/offense"
require_relative "canvas/checks"
require_relative "canvas/auth"

Dir[__dir__ + "/canvas/checks/*.rb"].each { |file| require file }

Canvas::Checks.register(Canvas::RequiredFilesCheck)
Canvas::Checks.register(Canvas::ValidHtmlCheck)

module Canvas
end
