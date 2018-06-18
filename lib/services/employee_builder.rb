# frozen_string_literal: true

module Services
  class EmployeeBuilder
    def initialize(args)
      @employee = args.fetch(:employee)
      @period = args.fetch(:period)
    end

    def build
      {
        name: @employee.name,
        pis: @employee.pis,
        workdays: workdays,
        balance_in_minutes: balance_in_minutes
      }
    end

    private

    def workdays
      @workdays ||= Services::WorkdaysBuilder
                    .new(employee: @employee, period: @period)
                    .build
    end

    def balance_in_minutes
      workdays
        .map { |day| day[:balance_time_in_minutes] }
        .reduce(:+)
    end
  end
end
