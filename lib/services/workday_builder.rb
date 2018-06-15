# frozen_string_literal: true

module Services
  class WorkdayBuilder
    def initialize(date:, entries:, workload:)
      @date = date
      @entries = entries
      @workload = workload
      @messages = []
    end

    def build
      validate_workday

      {
        date: @date,
        worked_time_in_minutes: worked_time_in_minutes,
        balance_time_in_minutes: balance_time_in_minutes,
        entries: entry_times,
        messages: @messages
      }
    end

    private

    def worked_time_in_minutes
      worked = worked_without_interval_time
      worked += extra_time if qualifies_to_additional?

      worked
    end

    def worked_without_interval_time
      total_time - interval
    end

    def balance_time_in_minutes
      worked_time_in_minutes - journey
    end

    def extra_time
      interval_left.positive? ? interval_left : 0
    end

    def qualifies_to_additional?
      worked_without_interval_time > half_journey
    end

    def interval
      (entrance_from_interval - leave_to_interval).to_i / 60
    end

    def total_time
      (leave - entrance).to_i / 60
    end

    def entry_times
      @entries.map do |entry|
        entry.strftime('%R')
      end
    end

    def leave_to_interval
      @entries[1] || 0
    end

    def entrance_from_interval
      @entries[2] || 0
    end

    def entrance
      @entries.first || 0
    end

    def leave
      @entries.last || 0
    end

    def interval_left
      @workload.rest_interval - interval
    end

    def journey
      @workload.daily_workload_time
    end

    def half_journey
      journey / 2
    end

    def did_rest_interval?
      @entries.count > 2 && @entries.count.even?
    end

    def validate_workday
      @messages << :missing_entry if @entries.count.odd?
      @messages << :absence if @entries.empty?
    end
  end
end
