# frozen_string_literal: true

require "cli/ui"

module Canvas
  #:documented:
  class Lint
    def run(scoped_files)
      output_context = CLI::UI::SpinGroup.new(auto_debrief: false)

      @checks = Checks.registered.map(&:new)

      @checks.each do |check|
        run_check(check, output_context, scoped_files)
      end

      output_context.wait

      if @checks.any?(&:failed?)
        puts debrief_message
        exit 1
      end
    end

    private

    def run_check(check, output_context, scoped_files)
      output_context.add(check.class.name) do
        check.run(scoped_files)
        raise if check.offenses.any?
      end
    end

    def debrief_message
      CLI::UI::Frame.open("Failures", color: :red) do
        failed_checks = @checks.filter(&:failed?)
        failed_checks.map do |check|
          CLI::UI::Frame.open(check.class.name, color: :red) do
            output = check.offenses.map { |offense|
              CLI::UI.fmt "{{x}} #{offense.message}"
            }
            puts output.join("\n")
          end
        end
      end
    end
  end
end
