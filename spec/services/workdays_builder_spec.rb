# frozen_string_literal: true

RSpec.describe Services::WorkdaysBuilder do
  describe '#build' do
    it 'returns an array of builded data' do
      name = 'Ze da Silva'
      pis = 87_654_432_154
      entries = [
        '2018-04-10T02:13:00',
        '2018-04-11T11:42:00',
        '2018-04-11T16:27:00',
        '2018-04-11T16:41:00',
        '2018-04-11T18:11:00',
        '2018-04-12T03:48:00',
        '2018-04-10T06:11:00',
        '2018-04-12T07:44:00',
        '2018-04-12T07:56:00',
        '2018-04-17T12:23:00',
        '2018-04-17T15:48:00',
        '2018-04-17T15:58:00',
        '2018-04-17T18:46:00',
        '2018-04-18T14:00:00',
        '2018-04-12T10:03:00',
        '2018-04-18T14:19:00',
        '2018-04-18T18:21:00',
        '2018-04-19T16:56:00',
        '2018-04-19T20:44:00',
        '2018-04-19T21:00:00',
        '2018-04-18T11:55:00',
        '2018-04-19T23:20:00'
      ].map { |entry| Time.parse(entry) }

      workload_args = {
        days: %w[mon tue wed thu fri],
        daily_workload_time: 300,
        daily_minimum_rest_interval: 30,
        rest_interval: 60
      }
      workload = Workload.new(workload_args)

      employee_args = {
        name: name,
        pis: pis,
        workload: workload,
        entries: entries
      }
      employee = Employee.new(employee_args)

      start_date = Date.parse('2018-04-10')
      end_date = Date.parse('2018-04-20')
      period = {
        start_date: start_date,
        end_date: end_date
      }
      params = { employee: employee, period: period }

      workdays_builder = described_class.new(params)

      expected_result = [
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
          worked_time_in_minutes: 375,
          balance_time_in_minutes: 75,
          entries: ['11:42', '16:27', '16:41', '18:11'],
          messages: %i[
            interval_left
            minimal_interval_not_reached
            extra_from_interval
          ]
        },
        {
          date: '2018-04-12',
          worked_time_in_minutes: 363,
          balance_time_in_minutes: 63,
          entries: ['03:48', '07:44', '07:56', '10:03'],
          messages: %i[
            interval_left
            minimal_interval_not_reached
            extra_from_interval
          ]
        },
        {
          date: '2018-04-17',
          worked_time_in_minutes: 373,
          balance_time_in_minutes: 73,
          entries: ['12:23', '15:48', '15:58', '18:46'],
          messages: %i[
            interval_left
            minimal_interval_not_reached
            extra_from_interval
          ]
        },
        {
          date: '2018-04-18',
          worked_time_in_minutes: 367,
          balance_time_in_minutes: 67,
          entries: ['11:55', '14:00', '14:19', '18:21'],
          messages: %i[
            interval_left
            minimal_interval_not_reached
            extra_from_interval
          ]
        },
        {
          date: '2018-04-19',
          worked_time_in_minutes: 368,
          balance_time_in_minutes: 68,
          entries: ['16:56', '20:44', '21:00', '23:20'],
          messages: %i[
            interval_left
            minimal_interval_not_reached
            extra_from_interval
          ]
        }
      ]

      expect(workdays_builder.build).to eq(expected_result)
    end
  end
end
