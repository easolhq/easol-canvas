require "fileutils"

module Canvas
  class LocalConfig
    extend SingleForwardable
    def_delegators :new, :set, :get

    def initialize
      @config_folder = FileUtils.mkdir_p(File.join(Dir.getwd, ".canvas"))
      @config = JSON.parse(File.read(File.join(@config_folder, "config.json")))
    end

    def get(key)
      @config[key.to_s]
    end
  end
end
