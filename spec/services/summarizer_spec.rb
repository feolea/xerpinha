# frozen_string_literal: true

RSpec.describe Services::Summarizer do
  describe '#execute' do
    it 'calls build on employee_builder and build data' do
      work_period = {
        today: '2018-06-19',
        period_start: '2018-06-10',
        employees: [{ name: 1 }, { name: 2 }]
      }

      employee_builder = double('Services::EmployeeBuilder', build: { a: true })

      allow(Services::EmployeeBuilder)
        .to receive(:new)
        .with(an_instance_of(Hash))
        .and_return employee_builder

      summarizer = described_class.new(work_period)

      expected_result = {
        period: {
          start_date: '2018-06-10',
          end_date: '2018-06-19'
        },
        employees: [{ a: true }, { a: true }]
      }

      expect(summarizer.execute).to eq(expected_result)
    end
  end
end
