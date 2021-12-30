module Canvas
  class Lint
    def run
      TemplateCheck.new.run 
    end
  end
end
