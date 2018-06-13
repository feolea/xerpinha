# frozen_string_literal: true

module Services
  class WorkdayBuilder
    def initialize(day_entries, workload)
      @entries = day_entries
      @workload = workload
      @messages = []
    end

    def build
      validate_workday

      {
        date: date,
        worked_time_in_minutes: worked_time_in_minutes,
        balance_time_in_minutes: balance_time_in_minutes,
        entries: entry_times,
        messages: @messages
      }
    end

    private

    def date
      entries.first.date
    end

    def worked_time_in_minutes
      worked = worked_without_interval_time
      worked += extra_time if qualifies_to_additional?

      worked
    end

    def worked_without_interval_time
      total_time - interval
    end

    def balance_time_in_minutes
      jorney - worked_time_in_minutes
    end

    def extra_time
      interval_left.positive? ? interval_left : 0
    end

    def qualifies_to_additional?
      worked_without_interval_time > half_jorney
    end

    def interval_left
      workload.rest_interval - interval
    end

    def jorney
      workload.daily_workload_time
    end

    def half_jorney
      jorney / 2
    end

    def did_rest_interval?
      entries.count > 2
    end

    def validate_workday
      @messages << :missing_entry if entries.count.odd?
      @messages << :absence if entries.empty?
    end
  end
end
