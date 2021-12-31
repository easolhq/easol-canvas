require_relative "canvas/version"
require_relative "canvas/cli"
require_relative "canvas/lint"
require_relative "canvas/validators/html"
require_relative "canvas/check"
require_relative "canvas/offense"

Dir[__dir__ + "/canvas/checks/*.rb"].each { |file| require file }

module Canvas
end
