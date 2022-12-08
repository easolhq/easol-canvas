require "fileutils"

module Canvas
  class LocalConfig
    extend SingleForwardable
    def_delegators :new, :set, :get, :delete

    def initialize
      @config_folder = FileUtils.mkdir_p(File.join(Dir.getwd, ".canvas"))
      @config_file = File.join(@config_folder, "config.json")
      unless File.exist?(@config_file)
        File.open(@config_file, 'w') { |file|
          file.write("{}")
        }
      end
      @config = JSON.parse(File.read(@config_file))
    end

    def get(key)
      @config[key.to_s]
    end

    def set(**args)
      args.each do |key, value|
        @config[key.to_s] = value
        File.open(@config_file, 'w') { |file|
          file.write(@config.to_json)
        }
      end
    end

    def delete(key)
      @config.delete(key.to_s)
      File.open(@config_file, 'w') { |file|
        file.write(@config.to_json)
      }
    end
  end
end
