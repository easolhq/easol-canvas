module Canvas
  class PartialsCheck < Check
    self.base_folder = "assets"

    require_file "footer/index.liquid"
    require_file "menu/index.liquid"

    validate_html "footer/index.liquid"
    validate_html "menu/index.liquid"
  end
end
