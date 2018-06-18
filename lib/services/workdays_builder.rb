# frozen_string_literal: true

module Services
  class WorkdaysBuilder
    def initialize(args)
      @employee = args.fetch(:employee)
      @period = args.fetch(:period)
    end

    def build
      entries_by_date.map do |date, entries|
        build_workday(date: date,
                      entries: entries,
                      workload: workload)
      end
    end

    private

    def build_workday(params)
      service = Strategies::WorkdaySummary.new(params).select

      service.execute
    end

    #
    # TO-DO: merge with days that are not in entries, ex. in case of an absence.
    #
    def entries_by_date
      employee_entries.group_by { |entry| entry.strftime('%F') }
    end

    def employee_entries
      @employee.entries.sort
    end

    def workload
      @workload ||= @employee.workload
    end
  end
end
