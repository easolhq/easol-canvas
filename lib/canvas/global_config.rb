require "pstore"
require "fileutils"

module Canvas
  class GlobalConfig
    extend SingleForwardable
    def_delegators :new, :set, :get, :merge

    def initialize
      @config_folder = FileUtils.mkdir_p(File.join(Dir.home, ".canvas"))
      @config = PStore.new(File.join(@config_folder, "config.pstore"))
    end

    def set(**args)
      @config.transaction do
        args.each do |key, value|
          if value.nil?
            @config.delete(key)
          else
            @config[key] = value
          end
        end
      end
    end

    def get(key)
      value = @config.transaction do
        @config[key]
      end
      value
    end

    def merge(key, **args)
      @config.transaction do
        @config[key] = (@config[key] || {}).merge(args)
      end
    end
  end
end
