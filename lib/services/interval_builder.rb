# frozen_string_literal: true

module Services
  class IntervalBuilder
    def initialize(entries:, workload:)
      @entries = entries
      @workload = workload
      @messages = []
    end

    def build
      validate_interval

      {
        expected: expected,
        made: made,
        balance: balance,
        minimum_expected: minimum_expected,
        exceeded?: exceeded?,
        left?: left?,
        messages: @messages
      }
    end

    private

    def expected
      @workload.rest_interval
    end

    def made
      return 0 if no_entries?
      return expected if missing_entry?

      (back_to_work - leave_to_interval).to_i / 60
    end

    def balance
      exceeded? ? 0 : (expected - made)
    end

    def minimum_expected
      @workload.daily_minimum_rest_interval
    end

    def exceeded?
      @exceeded ||= made > expected
    end

    def left?
      @left ||= made < expected
    end

    def back_to_work
      @entries.last
    end

    def leave_to_interval
      @entries.first
    end

    def less_than_minimum?
      made < minimum_expected
    end

    def missing_entry?
      @missing_entry ||= @entries.one?
    end

    def no_entries?
      @no_entries ||= @entries.empty?
    end

    def missing_interval?
      no_entries? && minimum_expected.positive?
    end

    def validate_interval
      if exceeded?
        @messages << :exceeded_interval
      elsif left?
        @messages << :interval_left
        @messages << :minimal_interval_not_reached if less_than_minimum?
        @messages << :missing_interval if missing_interval?
      elsif missing_entry?
        @messages << :missing_entry
      end
    end
  end
end
