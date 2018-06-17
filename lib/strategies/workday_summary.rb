# frozen_string_literal: true

module Strategies
  class WorkdaySummary
    def initialize(args)
      @date = args.fetch(:date)
      @entries = args.fetch(:entries, [])
      @workload = args.fetch(:workload)
    end

    def select
      worked? ? workaday : empty_day
    end

    private

    def worked?
      @entries.any?
    end

    def workaday
      Services::WorkdaySummary::Workaday.new(entries: @entries,
                                             workload: @workload)
    end

    def empty_day
      Services::WorkdaySummary::EmptyDay.new(date: @date, workload: @workload)
    end
  end
end
