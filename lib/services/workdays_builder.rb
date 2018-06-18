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

    def entries_by_date
      build_period(start_date, end_date)
    end

    def build_period(start_date, date)
      return {} if date < start_date

      build_period(start_date, date.prev_day)
        .merge(
          date.strftime('%F') =>
          entries_in_time.select { |entry| entry.to_date.eql? date }
        )
    end

    def entries_in_time
      @entries_in_time ||= employee_entries.map { |entry| Time.parse(entry) }
    end

    def employee_entries
      @employee_entries ||= @employee.entries.sort
    end

    def workload
      @workload ||= @employee.workload
    end

    def start_date
      Date.parse(@period[:start_date])
    end

    def end_date
      Date.parse(@period[:end_date])
    end
  end
end
