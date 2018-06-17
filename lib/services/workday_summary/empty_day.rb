# frozen_string_literal: true

module Services
  module WorkdaySummary
    class EmptyDay
      def initialize(date:, workload:)
        @date = date
        @workload = workload
        @messages = []
      end

      def execute
        {
          date: @date,
          worked_time_in_minutes: 0,
          balance_time_in_minutes: balance_time_in_minutes,
          entries: [],
          messages: @messages
        }
      end

      private

      def balance_time_in_minutes
        if working_day?
          @messages << :absence

          @workload.daily_workload_time * -1
        else
          @messages << :rest_day

          0
        end
      end

      def week_day
        Time.parse(@date).strftime('%a').downcase
      end

      def working_day?
        working_days.include? week_day
      end

      def working_days
        @workload.days.map(&:downcase)
      end
    end
  end
end
