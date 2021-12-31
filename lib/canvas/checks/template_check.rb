module Canvas
  class TemplateCheck < Check
    self.base_folder = "templates"

    require_file "product/index.liquid"
    require_file "blog_overview/index.liquid"
    require_file "blog_post/index.liquid"

    validate_html "blog_overview/index.liquid"
    validate_html "blog_post/index.liquid"
    validate_html "content/index.liquid"
    validate_html "product/index.liquid"
    validate_html "selections/index.liquid"
  end
end
