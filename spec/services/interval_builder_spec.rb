# frozen_string_literal: true

RSpec.describe Services::IntervalBuilder do
  describe '#build' do
    context 'with no entries' do
      context 'and no minimal rest' do
        it 'do not add missing_interval message' do
          interval_entries = []
          workload_args = {
            daily_workload_time: 240,
            daily_minimum_rest_interval: 0,
            days: %w[mon tue wed thu fri],
            rest_interval: 30
          }
          workload = Workload.new(workload_args)

          interval = described_class.new(entries: interval_entries,
                                         workload: workload)

          expected_result = {
            expected: 30,
            made: 0,
            balance: 30,
            minimum_expected: 0,
            exceeded?: false,
            left?: true,
            messages: [:interval_left]
          }

          expect(interval.build).to eq(expected_result)
        end
      end

      context 'with minimal rest' do
        it 'adds missing_interval message' do
          interval_entries = []
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          interval = described_class.new(entries: interval_entries,
                                         workload: workload)

          expected_result = {
            expected: 60,
            made: 0,
            balance: 60,
            minimum_expected: 15,
            exceeded?: false,
            left?: true,
            messages: %i[
              interval_left
              minimal_interval_not_reached
              missing_interval
            ]
          }

          expect(interval.build).to eq(expected_result)
        end
      end
    end

    context 'with one entry only' do
      it 'adds missing_entry message and assumes expected_interval' do
        interval_entries = [Time.parse('2018-04-11T12:00:00')]
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 15,
          days: %w[mon tue wed thu fri],
          rest_interval: 60
        }
        workload = Workload.new(workload_args)

        interval = described_class.new(entries: interval_entries,
                                       workload: workload)

        expected_result = {
          expected: 60,
          made: 60,
          balance: 0,
          minimum_expected: 15,
          exceeded?: false,
          left?: false,
          messages: [:missing_entry]
        }

        expect(interval.build).to eq(expected_result)
      end
    end

    context 'with two entries' do
      context 'and exactly time of expected interval' do
        it 'builds interval data' do
          interval_entries = [
            Time.parse('2018-04-11T12:00:00'),
            Time.parse('2018-04-11T13:00:00')
          ]
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          interval = described_class.new(entries: interval_entries,
                                         workload: workload)

          expected_result = {
            expected: 60,
            made: 60,
            balance: 0,
            minimum_expected: 15,
            exceeded?: false,
            left?: false,
            messages: []
          }

          expect(interval.build).to eq(expected_result)
        end
      end

      context 'and more time than expected interval' do
        it 'adds exceeded_interval message' do
          interval_entries = [
            Time.parse('2018-04-11T12:00:00'),
            Time.parse('2018-04-11T13:01:00')
          ]
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          interval = described_class.new(entries: interval_entries,
                                         workload: workload)

          expected_result = {
            expected: 60,
            made: 61,
            balance: 0,
            minimum_expected: 15,
            exceeded?: true,
            left?: false,
            messages: [:exceeded_interval]
          }

          expect(interval.build).to eq(expected_result)
        end
      end

      context 'and time left from expected interval' do
        context 'made exactly or more than minimum expected' do
          it 'adds interval_left message' do
            interval_entries = [
              Time.parse('2018-04-11T12:00:00'),
              Time.parse('2018-04-11T12:15:00')
            ]
            workload_args = {
              daily_workload_time: 480,
              daily_minimum_rest_interval: 15,
              days: %w[mon tue wed thu fri],
              rest_interval: 60
            }
            workload = Workload.new(workload_args)

            interval = described_class.new(entries: interval_entries,
                                           workload: workload)

            expected_result = {
              expected: 60,
              made: 15,
              balance: 45,
              minimum_expected: 15,
              exceeded?: false,
              left?: true,
              messages: [:interval_left]
            }

            expect(interval.build).to eq(expected_result)
          end
        end

        context 'made less than minimum expected' do
          it 'adds interval_left and minimal_interval_not_reached message' do
            interval_entries = [
              Time.parse('2018-04-11T12:00:00'),
              Time.parse('2018-04-11T12:14:00')
            ]
            workload_args = {
              daily_workload_time: 480,
              daily_minimum_rest_interval: 15,
              days: %w[mon tue wed thu fri],
              rest_interval: 60
            }
            workload = Workload.new(workload_args)

            interval = described_class.new(entries: interval_entries,
                                           workload: workload)

            expected_result = {
              expected: 60,
              made: 14,
              balance: 46,
              minimum_expected: 15,
              exceeded?: false,
              left?: true,
              messages: %i[interval_left minimal_interval_not_reached]
            }

            expect(interval.build).to eq(expected_result)
          end
        end
      end
    end

    context 'with more than two entries' do
      xit 'group intervals' do # future release LoL
        interval_entries = [
          Time.parse('2018-04-11T12:00:00'),
          Time.parse('2018-04-11T12:30:00'),
          Time.parse('2018-04-11T16:00:00'),
          Time.parse('2018-04-11T16:30:00')
        ]
        workload_args = {
          daily_workload_time: 480,
          daily_minimum_rest_interval: 15,
          days: %w[mon tue wed thu fri],
          rest_interval: 60
        }
        workload = Workload.new(workload_args)

        interval = described_class.new(entries: interval_entries,
                                       workload: workload)

        expected_result = {
          expected: 60,
          made: 60,
          balance: 0,
          minimum_expected: 15,
          exceeded?: false,
          left?: false,
          messages: []
        }

        expect(interval.build).to eq(expected_result)
      end
    end
  end
end
