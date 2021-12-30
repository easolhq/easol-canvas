module Canvas
  class Check
    class << self
      attr_reader :required_files
      attr_accessor :base_folder
      def require_file(filename)
        @required_files ||= []
        @required_files << filename
      end
    end

    attr_reader :offenses

    def initialize
      @offenses = []
    end

    def run
      check_required_files
    end

    def check_required_files
      self.class.required_files.each do |filename|
        unless File.exists?("#{self.class.base_folder}/#{filename}")
          @offenses << Offense.new(
            message: "Missing file: #{filename}"
          )
        end
      end
    end
  end
end
