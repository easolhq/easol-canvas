module Canvas
  class PartialsCheck < Check
    self.base_folder = "assets"

    validate_html "footer/index.liquid"
    validate_html "menu/index.liquid"
  end
end
