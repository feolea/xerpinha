# frozen_string_literal: true

RSpec.describe Strategies::WorkdaySummary do
  describe '#select' do
    context 'with no entries' do
      it 'returns an instance of EmptyDay service' do
        date = '2018-11-06'
        entries = []
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 0,
          days: %w[mon tue wed thu fri],
          rest_interval: 30
        }
        workload = Workload.new(workload_args)
        params = {
          date: date,
          entries: entries,
          workload: workload
        }

        strategie = described_class.new(params)

        expect(strategie.select)
          .to be_an_instance_of(Services::WorkdaySummary::EmptyDay)
      end
    end

    context 'with entries' do
      it 'returns an instance of Workaday service' do
        date = '2018-11-06'
        entries = [Time.parse('2018-04-11T08:00:00')]
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 0,
          days: %w[mon tue wed thu fri],
          rest_interval: 30
        }
        workload = Workload.new(workload_args)
        params = {
          date: date,
          entries: entries,
          workload: workload
        }

        strategie = described_class.new(params)

        expect(strategie.select)
          .to be_an_instance_of(Services::WorkdaySummary::Workaday)
      end
    end
  end
end
