# frozen_string_literal: true

module Services
  module WorkdaySummary
    class Workaday
      def initialize(entries:, workload:)
        @entries = entries
        @workload = workload
        @interval = IntervalBuilder
                    .new(entries: interval_entries, workload: @workload)
                    .build
        @messages = @interval[:messages]
      end

      def execute
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
        @entries.first.strftime('%F')
      end

      def worked_time_in_minutes
        @worked_time_in_minutes ||= begin
          worked = worked_without_interval
          worked += @interval[:balance] if add_interval_balance?

          worked
        end
      end

      def balance_time_in_minutes
        worked_time_in_minutes - journey
      end

      def entry_times
        @entries.map do |entry|
          entry.strftime('%R')
        end
      end

      def interval_entries
        _first, *leftover = @entries
        leftover.pop

        leftover
      end

      def worked_without_interval
        total_time - @interval[:expected]
      end

      def qualifies_to_additional?
        !less_than_half_journey?
      end

      def add_interval_balance?
        @interval[:left?] &&
          qualifies_to_additional? &&
          @messages << :extra_from_interval
      end

      def total_time
        (leave - entrance).to_i / 60
      end

      def entrance
        @entries.first
      end

      def leave
        @entries.last
      end

      def journey
        @journey ||= @workload.daily_workload_time
      end

      def half_journey
        journey / 2
      end

      def less_than_half_journey?
        worked_without_interval < half_journey &&
          @messages << :less_than_half_journey
      end
    end
  end
end
