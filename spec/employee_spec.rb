# frozen_string_literal: true

RSpec.describe Employee do
  describe '#new' do
    context 'without some required argument' do
      it 'raises an error' do
        required_args = {
          pis: 123_456,
          name: 'Josef Blatter'
        }

        required_args.keys.each do |arg|
          args_without_key = required_args.reject { |key| key == arg }

          expect { described_class.new(args_without_key) }
            .to raise_error(KeyError, /#{arg}/)
        end
      end
    end

    context 'with all required arguments' do
      it 'does not raise an error' do
        args = {
          pis: 123_456,
          name: 'Josef Blatter',
          workload: double('Workload', days: %w[mon tue])
        }

        expect { described_class.new(args) }.to_not raise_error
      end
    end
  end

  describe '#pis' do
    it 'returns the employee\'s pis' do
      # setup
      args = {
        pis: 123_456,
        name: 'Josef Blatter'
      }

      # exercise
      employee = described_class.new(args)

      # verify
      expect(employee.pis).to eq(123_456)
    end
  end

  describe '#name' do
    it 'returns the employee\'s name' do
      name = 'Josef Blatter'
      args = {
        pis: 123_456,
        name: name
      }

      employee = described_class.new(args)

      expect(employee.name).to eq(name)
    end
  end

  describe '#workload' do
    context 'when workload instance was suplied' do
      it 'returns the workload instance' do
        workload = instance_double('Workload')
        args = {
          name: 'Xerpie Lennon',
          pis: 987_678_755,
          workload: workload
        }

        employee = described_class.new(args)

        expect(employee.workload).to be(workload)
      end
    end

    context 'when there is no workload in args' do
      it 'returns nil' do
        args = {
          pis: 123_456,
          name: 'Josef Blatter'
        }

        employee = described_class.new(args)

        expect(employee.workload).to be nil
      end
    end
  end

  describe '#entries' do
    context 'when entries was suplied' do
      it 'returns the entries instance' do
        entries = Array.new(2, 2)
        args = {
          name: 'Xerpie Lennon',
          pis: 987_678_755,
          entries: entries
        }

        employee = described_class.new(args)

        expect(employee.entries).to be(entries)
      end
    end

    context 'when there is no entries in args' do
      it 'returns nil' do
        args = {
          pis: 123_456,
          name: 'Josef Blatter'
        }

        employee = described_class.new(args)

        expect(employee.entries).to be nil
      end
    end
  end
end
