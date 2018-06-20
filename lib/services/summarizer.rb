# frozen_string_literal: true

module Services
  class Summarizer
    def initialize(work_period)
      @work_period = work_period
    end

    def execute
      {
        period: period,
        employees: build_employees
      }
    end

    private

    def build_employees
      employees.map do |employee|
        Services::EmployeeBuilder.new(employee: employee, period: period).build
      end
    end

    def period
      {
        start_date: @work_period[:period_start],
        end_date: @work_period[:today]
      }
    end

    def employees
      @work_period[:employees]
    end
  end
end
