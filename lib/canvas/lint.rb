require 'cli/ui'

module Canvas
  class Lint
    def run
      output_context = CLI::UI::SpinGroup.new(auto_debrief: false)

      checks = [
        TemplateCheck.new,
        AssetsCheck.new,
        PartialsCheck.new
      ]

      checks.each do |check|
        run_check(check, output_context)
      end

      output_context.wait

      if checks.any?(&:failed?)
        puts "Failures!"
      end
    end

    private

    def run_check(check, output_context)
      output_context.add(check.class.name) do
        check.run
        raise if check.offenses.any?
      end
    end
  end
end
