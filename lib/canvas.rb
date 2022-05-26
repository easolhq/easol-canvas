require_relative "canvas/version"
require_relative "canvas/constants"
require_relative "canvas/cli"
require_relative "canvas/lint"
require_relative "canvas/check"
require_relative "canvas/offense"
require_relative "canvas/checks"

# We need to ensure Canvas::Validator::SchemaAttribute::Base is required first
require_relative "canvas/validators/schema_attributes/base"

# The attribute validators need to be required before Canvas::Validator::SchemaAttribute
attribute_validators = Dir["#{__dir__}/canvas/validators/schema_attributes/*.rb"]
attribute_validators.each { |file| require file }

files = Dir["#{__dir__}/canvas/{checks,services,validators}/*.rb"]
files.each { |file| require file }

Canvas::Checks.register(Canvas::RequiredFilesCheck)
Canvas::Checks.register(Canvas::ValidHtmlCheck)
Canvas::Checks.register(Canvas::ValidLiquidCheck)
Canvas::Checks.register(Canvas::ValidBlockSchemasCheck)
Canvas::Checks.register(Canvas::ValidMenuSchemaCheck)

module Canvas
end
