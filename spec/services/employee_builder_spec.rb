# frozen_string_literal: true

RSpec.describe Services::EmployeeBuilder do
  describe '#build' do
    it 'builds employee data' do
      name = 'Ze da Silva'
      pis = 87_654_432_154
      entries = [
        '2018-04-10T02:13:00',
        '2018-04-11T11:42:00',
        '2018-04-11T16:20:00',
        '2018-04-11T16:41:00',
        '2018-04-11T18:11:00',
        '2018-04-10T06:11:00'
      ]

      workload = {
        days: %w[mon tue wed thu fri],
        workload_in_minutes: 300,
        minimum_rest_interval_in_minutes: 15
      }

      employee = {
        name: name,
        pis_number: pis,
        workload: workload,
        entries: entries
      }

      start_date = '2018-04-10'
      end_date = '2018-04-11'
      period = {
        start_date: start_date,
        end_date: end_date
      }

      params = { employee: employee, period: period }

      employee_builder = described_class.new(params)

      expected_result = {
        name: 'Ze da Silva',
        pis: 87_654_432_154,
        workdays: [
          {
            date: '2018-04-10',
            worked_time_in_minutes: 238,
            balance_time_in_minutes: -62,
            entries: ['02:13', '06:11'],
            messages: %i[
              interval_left
              minimal_interval_not_reached
              missing_interval
              extra_from_interval
            ]
          },
          {
            date: '2018-04-11',
            worked_time_in_minutes: 368,
            balance_time_in_minutes: 68,
            entries: ['11:42', '16:20', '16:41', '18:11'],
            messages: %i[
              interval_left
              extra_from_interval
            ]
          }
        ],
        balance_in_minutes: 6
      }

      expect(employee_builder.build).to eq(expected_result)
    end
  end
end
