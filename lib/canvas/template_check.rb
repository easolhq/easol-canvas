module Canvas
  class TemplateCheck < Check
    self.base_folder = "templates"
    require_file "product/index.liquid"
  end
end
