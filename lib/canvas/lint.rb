require 'cli/ui'

module Canvas
  class Lint
    def run
      output_context = CLI::UI::SpinGroup.new(auto_debrief: false)

      @checks = Checks.registered.map(&:new)

      @checks.each do |check|
        run_check(check, output_context)
      end

      output_context.wait

      if @checks.any?(&:failed?)
        puts debrief_message
      end
    end

    private

    def run_check(check, output_context)
      output_context.add(check.class.name) do
        check.run
        raise if check.offenses.any?
      end
    end

    def debrief_message
      CLI::UI::Frame.open('Failures', color: :red) do
        failed_checks = @checks.filter(&:failed?)
        failed_checks.map do |check|
          CLI::UI::Frame.open(check.class.name, color: :red) do
            output = check.offenses.map do |offense|
              CLI::UI.fmt "{{x}} #{offense.message}"
            end
            puts output.join("\n")
          end
        end
      end
    end
  end
end
