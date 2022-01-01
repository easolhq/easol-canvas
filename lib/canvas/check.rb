require 'cli/ui'

module Canvas
  class Check
    class << self
      attr_reader :html_files
      attr_accessor :base_folder

      def html_files
        @html_files ||= []
      end

      def validate_html(filename)
        @html_files ||= []
        @html_files << filename
      end
    end

    attr_reader :offenses

    def initialize
      @offenses = []
    end

    def run
      check_html_files
    end

    def failed?
      @offenses.any?
    end

    private

    def check_html_files
      self.class.html_files.each do |filename|
        filename = "#{self.class.base_folder}/#{filename}"
        next unless File.exists?(filename)
        file = File.read(filename)
        validator = Validator::Html.new(file)
        unless validator.validate
          @offenses << Offense.new(
            message: "Invalid HTML: #{filename} - #{validator.errors.map(&:message).join(', ')}",
          )
        end
      end
    end
  end
end
