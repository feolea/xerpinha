# frozen_string_literal: true

RSpec.describe WorkPeriod do
  describe '#start_date' do
    it 'returns start date' do
      start_date = '2018-01-01'
      args = {
        start_date: start_date,
        end_date: '2018-01-23',
        employees: []
      }

      work_period = described_class.new(args)

      expect(work_period.start_date).to eq(start_date)
    end
  end

  describe '#end_date' do
    it 'returns end date' do
      end_date = '2018-01-23'
      args = {
        start_date: '2018-01-01',
        end_date: end_date,
        employees: []
      }

      work_period = described_class.new(args)

      expect(work_period.end_date).to eq(end_date)
    end
  end

  describe '#employees' do
  end
end
