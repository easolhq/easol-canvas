require 'cli/ui'

module Canvas
  class Linker
    Error = Class.new(StandardError)

    def link(path, resource)
      check_path_exists(path)
      check_path_isnt_directory(path)
      check_resource_isnt_linked(resource)

      Canvas::Config.merge(:links, path => resource)
    end

    private
    
    def check_path_exists(path)
      unless File.exists? path
        raise Error.new("#{path} No such file")
      end
    end

    def check_path_isnt_directory(path)
      if File.directory? path
        raise Error.new("#{path} is a directory")
      end
    end

    def check_resource_isnt_linked(resource)
      links = Canvas::Config.get(:links) || {}
      if path = links.invert[resource]
        raise Error.new("#{resource} already linked to #{path}")
      end
    end
  end
end
