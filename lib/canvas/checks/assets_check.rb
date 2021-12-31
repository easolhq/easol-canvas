module Canvas
  class AssetsCheck < Check
    self.base_folder = "assets"

    require_file "index.css"
    require_file "index.js"

=begin
    TODO
    validate_css "index.css"
    validate_css "reocmmendation.css"

    Maybe todo?
    validate_js  "index.js"
=end
  end
end
