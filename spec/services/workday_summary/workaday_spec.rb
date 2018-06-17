# frozen_string_literal: true

RSpec.describe Services::WorkdaySummary::Workaday do
  describe '#execute' do
    context 'with exactly time of interval' do
      it 'does not add nor deduct time' do
        entries = [
          Time.parse('2018-04-11T08:00:00'),
          Time.parse('2018-04-11T12:00:00'),
          Time.parse('2018-04-11T13:00:00'),
          Time.parse('2018-04-11T17:00:00')
        ]
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 15,
          days: %w[mon tue wed thu fri],
          rest_interval: 60
        }
        workload = Workload.new(workload_args)

        workaday_summary = described_class.new(entries: entries,
                                               workload: workload)

        expected_result = {
          date: '2018-04-11',
          worked_time_in_minutes: 480,
          balance_time_in_minutes: 0,
          entries: ['08:00', '12:00', '13:00', '17:00'],
          messages: []
        }

        expect(workaday_summary.execute).to eq(expected_result)
      end
    end

    context 'with one or more minutes of interval' do
      it 'adds exceeded_interval message but does not deduct time' do
        entries = [
          Time.parse('2018-04-11T08:00:00'),
          Time.parse('2018-04-11T12:00:00'),
          Time.parse('2018-04-11T13:01:00'),
          Time.parse('2018-04-11T17:00:00')
        ]
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 15,
          days: %w[mon tue wed thu fri],
          rest_interval: 60
        }
        workload = Workload.new(workload_args)

        workaday_summary = described_class.new(entries: entries,
                                               workload: workload)

        expected_result = {
          date: '2018-04-11',
          worked_time_in_minutes: 480,
          balance_time_in_minutes: 0,
          entries: ['08:00', '12:00', '13:01', '17:00'],
          messages: [:exceeded_interval]
        }

        expect(workaday_summary.execute).to eq(expected_result)
      end
    end

    context 'with time left of interval' do
      context 'and 50% or more of journey' do
        it 'adds the time left to balance time' do
          entries = [
            Time.parse('2018-04-11T10:00:00'),
            Time.parse('2018-04-11T12:00:00'),
            Time.parse('2018-04-11T12:30:00'),
            Time.parse('2018-04-11T15:00:00')
          ]
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          workaday_summary = described_class.new(entries: entries,
                                                 workload: workload)

          expected_result = {
            date: '2018-04-11',
            worked_time_in_minutes: 270,
            balance_time_in_minutes: -210,
            entries: ['10:00', '12:00', '12:30', '15:00'],
            messages: %i[interval_left extra_from_interval]
          }

          expect(workaday_summary.execute).to eq(expected_result)
        end
      end

      context 'and less than 50% of daily journey' do
        it 'does not add time left to balance time' do
          entries = [
            Time.parse('2018-04-11T10:00:00'),
            Time.parse('2018-04-11T12:00:00'),
            Time.parse('2018-04-11T12:30:00'),
            Time.parse('2018-04-11T14:59:00')
          ]
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          workaday_summary = described_class.new(entries: entries,
                                                 workload: workload)

          expected_result = {
            date: '2018-04-11',
            worked_time_in_minutes: 239,
            balance_time_in_minutes: -241,
            entries: ['10:00', '12:00', '12:30', '14:59'],
            messages: %i[interval_left less_than_half_journey]
          }

          expect(workaday_summary.execute).to eq(expected_result)
        end
      end
    end
  end
end
