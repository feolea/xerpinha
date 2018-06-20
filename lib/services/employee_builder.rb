# frozen_string_literal: true

module Services
  class EmployeeBuilder
    def initialize(args)
      @employee = init_employee(args.fetch(:employee))
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

    DEFAULT_INTERVAL = 60
    private_constant :DEFAULT_INTERVAL

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

    def init_employee(payload)
      params = employee_params(payload)

      Employee.new(params)
    end

    def employee_params(payload)
      {
        name: payload[:name],
        pis: payload[:pis_number],
        workload: init_workload(payload[:workload]),
        entries: payload.fetch(:entries, [])
      }
    end

    def init_workload(workload_payload)
      params = workload_params(workload_payload)

      Workload.new(params)
    end

    def workload_params(workload_payload)
      {
        days: workload_payload[:days],
        daily_workload_time: workload_payload[:workload_in_minutes],
        daily_minimum_rest_interval:
          workload_payload[:minimum_rest_interval_in_minutes],
        rest_interval: workload_payload.fetch(:rest_interval, DEFAULT_INTERVAL)
      }
    end
  end
end
