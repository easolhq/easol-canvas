# frozen_string_literal: true

require "cli/ui"

module Canvas
  #:documented:
  class Lint
    def run
      spin_group = CLI::UI::SpinGroup.new(auto_debrief: false)

      @failed_checks = {}

      checks = Checks.registered.map(&:new)
      checks.each do |check|
        run_check(check, spin_group)
      end

      spin_group.wait

      if @failed_checks.any?
        puts debrief_message
        exit 1
      end
    end

    private

    def run_check(check, spin_group)
      offenses = run_check_and_return_offenses(check)

      output_check(
        spin_group,
        name: check.class.name,
        success: offenses.empty?
      )

      if offenses.any?
        @failed_checks[check.class.name] = offenses
      end
    end

    def output_check(spin_group, name:, success:)
      spin_group.add(name) do
        raise if !success
      end
    end

    def run_check_and_return_offenses(check)
      check.run
      check.offenses.map(&:message)
    rescue => ex
      [ex.message + "\n" + ex.backtrace.join("\n")]
    end

    def debrief_message
      CLI::UI::Frame.open("Failures", color: :red) do
        @failed_checks.map do |check_name, messages|
          CLI::UI::Frame.open(check_name, color: :red) do
            output = messages.map { |message|
              CLI::UI.fmt "{{x}} #{message}"
            }
            puts output.join("\n")
          end
        end
      end
    end
  end
end
