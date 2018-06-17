# frozen_string_literal: true

RSpec.describe Services::WorkdaySummary::EmptyDay do
  describe '#execute' do
    context 'within working days' do
      it 'adds absence message and deduct balance' do
        date = '2018-04-11' # wednesday
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 15,
          days: %w[mon tue wed thu fri],
          rest_interval: 60
        }
        workload = Workload.new(workload_args)

        empty_day_summary = described_class.new(date: date,
                                                workload: workload)

        expected_result = {
          date: '2018-04-11',
          worked_time_in_minutes: 0,
          balance_time_in_minutes: -480,
          entries: [],
          messages: [:absence]
        }

        expect(empty_day_summary.execute).to eq(expected_result)
      end
    end

    context 'out of working days' do
      it 'adds rest_day message and do not deduct time' do
        date = '2018-04-14' # saturday
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 15,
          days: %w[mon tue wed thu fri],
          rest_interval: 60
        }
        workload = Workload.new(workload_args)

        empty_day_summary = described_class.new(date: date,
                                                workload: workload)

        expected_result = {
          date: '2018-04-14',
          worked_time_in_minutes: 0,
          balance_time_in_minutes: 0,
          entries: [],
          messages: [:rest_day]
        }

        expect(empty_day_summary.execute).to eq(expected_result)
      end
    end

    context 'on holidays' do
      it 'adds holiday message and do not deduct time' do
        # future release
      end
    end

    context 'on vacation' do
      it 'adds vacation message and do not deduct time' do
        # future release
      end
    end
  end
end
