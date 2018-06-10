# frozen_string_literal: true

RSpec.describe Workload do
  describe '#new' do
    context 'without some argument' do
      it 'raises an error' do
        args = {
          days: %w[mon tue wed thu fri],
          daily_workload_time: 300,
          daily_minimum_rest_interval: 30
        }

        args.keys.each do |arg|
          args_without_key = args.reject { |key| key == arg }

          expect { Workload.new(args_without_key) }
            .to raise_error(KeyError, /#{arg}/)
        end
      end
    end

    context 'with all arguments' do
      it 'does not raise an error' do
        args = {
          days: %w[mon tue],
          daily_workload_time: 300,
          daily_minimum_rest_interval: 30
        }

        expect { Workload.new(args) }.to_not raise_error
      end
    end
  end

  describe '#days' do
    it 'returns the days' do
      days = %w[mon tue wed thu fri]
      args = {
        days: days,
        daily_workload_time: 300,
        daily_minimum_rest_interval: 30
      }

      workload = Workload.new(args)

      expect(workload.days).to eq(days)
    end
  end

  describe '#daily_workload_time' do
    it 'returns the same amount of time' do
      daily_workload_time = 300
      args = {
        days: %w[mon tue wed thu fri],
        daily_workload_time: daily_workload_time,
        daily_minimum_rest_interval: 30
      }

      workload = Workload.new(args)

      expect(workload.daily_workload_time).to eq(daily_workload_time)
    end
  end

  describe '#daily_minimum_rest_interval' do
    it 'returns the same interval' do
      daily_minimum_rest_interval = 15
      args = {
        days: %w[mon tue wed thu fri],
        daily_workload_time: 240,
        daily_minimum_rest_interval: daily_minimum_rest_interval
      }

      workload = Workload.new(args)

      expect(workload.daily_minimum_rest_interval)
        .to eq(daily_minimum_rest_interval)
    end
  end
end
