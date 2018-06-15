# frozen_string_literal: true

RSpec.describe Services::WorkdayBuilder do
  describe '#build' do
    context 'within working days' do
      context 'without interval rest' do
        context 'and minimum rest interval is zero' do
          it 'does not add missing_interval message' do
            date = '2018-04-11'
            entries = [
              Time.parse('2018-04-11T08:00:00'),
              Time.parse('2018-04-11T16:00:00')
            ]
            workload_args = {
              daily_workload_time: 480,
              daily_minimum_rest_interval: 0,
              days: %w[mon tue wed thu fri],
              rest_interval: 30
            }
            workload = Workload.new(workload_args)

            workday_builder = described_class.new(date: date,
                                                  entries: entries,
                                                  workload: workload)

            expected_result = {
              date: '2018-04-11',
              worked_time_in_minutes: 480,
              balance_time_in_minutes: 0,
              entries: ['08:00', '17:00'],
              messages: []
            }

            expect(workday_builder.build).to eq(expected_result)
          end
        end

        context 'and minimum rest interval was not reached' do
          it 'adds missing_interval message' do
            date = '2018-04-11'
            entries = [
              Time.parse('2018-04-11T08:00:00'),
              Time.parse('2018-04-11T16:00:00')
            ]
            workload_args = {
              daily_workload_time: 480,
              daily_minimum_rest_interval: 15,
              days: %w[mon tue wed thu fri],
              rest_interval: 60
            }
            workload = Workload.new(workload_args)

            workday_builder = described_class.new(date: date,
                                                  entries: entries,
                                                  workload: workload)

            expected_result = {
              date: '2018-04-11',
              worked_time_in_minutes: 480,
              balance_time_in_minutes: 0,
              entries: ['08:00', '17:00'],
              messages: [:missing_interval]
            }

            expect(workday_builder.build).to eq(expected_result)
          end
        end
      end

      context 'with interval rest' do
        context 'and left time of interval' do
          context 'and more than 50% of journey' do
            it 'adds the time left to balance time' do
              date = '2018-04-11'
              entries = [
                Time.parse('2018-04-11T08:00:00'),
                Time.parse('2018-04-11T12:00:00'),
                Time.parse('2018-04-11T12:30:00'),
                Time.parse('2018-04-11T17:00:00')
              ]
              workload_args = {
                daily_workload_time: 480,
                daily_minimum_rest_interval: 15,
                days: %w[mon tue wed thu fri],
                rest_interval: 60
              }
              workload = Workload.new(workload_args)

              workday_builder = described_class.new(date: date,
                                                    entries: entries,
                                                    workload: workload)

              expected_result = {
                date: '2018-04-11',
                worked_time_in_minutes: 510,
                balance_time_in_minutes: 30,
                entries: ['08:00', '12:00', '12:30', '17:00'],
                messages: [:extra_from_interval]
              }

              expect(workday_builder.build).to eq(expected_result)
            end
          end

          context 'and less than 50% of daily journey' do
            it 'does not add time left to balance time' do
              date = '2018-04-11'
              entries = [
                Time.parse('2018-04-11T11:00:00'),
                Time.parse('2018-04-11T12:00:00'),
                Time.parse('2018-04-11T12:30:00'),
                Time.parse('2018-04-11T14:00:00')
              ]
              workload_args = {
                daily_workload_time: 480,
                daily_minimum_rest_interval: 15,
                days: %w[mon tue wed thu fri],
                rest_interval: 60
              }
              workload = Workload.new(workload_args)

              workday_builder = described_class.new(date: date,
                                                    entries: entries,
                                                    workload: workload)

              expected_result = {
                date: '2018-04-11',
                worked_time_in_minutes: 120,
                balance_time_in_minutes: -360,
                entries: ['08:00', '12:00', '13:00', '17:00'],
                messages: [:less_than_half_journey]
              }

              expect(workday_builder.build).to eq(expected_result)
            end
          end
        end

        context 'and exactly time of interval' do
          it 'does not add nor deduct time' do
            date = '2018-04-11'
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

            workday_builder = described_class.new(date: date,
                                                  entries: entries,
                                                  workload: workload)

            expected_result = {
              date: '2018-04-11',
              worked_time_in_minutes: 480,
              balance_time_in_minutes: 0,
              entries: ['08:00', '12:00', '13:00', '17:00'],
              messages: []
            }

            expect(workday_builder.build).to eq(expected_result)
          end
        end

        context 'and one or more minutes of interval' do
          it 'adds exceeded_interval message but does not deduct time' do
            date = '2018-04-11'
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

            workday_builder = described_class.new(date: date,
                                                  entries: entries,
                                                  workload: workload)

            expected_result = {
              date: '2018-04-11',
              worked_time_in_minutes: 480,
              balance_time_in_minutes: 0,
              entries: ['08:00', '12:00', '13:01', '17:00'],
              messages: [:exceeded_interval]
            }

            expect(workday_builder.build).to eq(expected_result)
          end
        end
      end

      context 'with odd entries' do
        it 'adds missing_entry message and do not add nor deduct time' do
          date = '2018-04-11'
          entries = [
            Time.parse('2018-04-11T08:00:00'),
            Time.parse('2018-04-11T12:00:00'),
            Time.parse('2018-04-11T17:00:00')
          ]
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          workday_builder = described_class.new(date: date,
                                                entries: entries,
                                                workload: workload)

          expected_result = {
            date: '2018-04-11',
            worked_time_in_minutes: 480,
            balance_time_in_minutes: 0,
            entries: ['08:00', '12:00', '17:00'],
            messages: [:missing_entry]
          }

          expect(workday_builder.build).to eq(expected_result)
        end
      end

      context 'with no entries' do
        it 'adds absence message' do
          date = '2018-04-11'
          entries = []
          workload_args = {
            daily_workload_time: 480,
            daily_minimum_rest_interval: 15,
            days: %w[mon tue wed thu fri],
            rest_interval: 60
          }
          workload = Workload.new(workload_args)

          workday_builder = described_class.new(date: date,
                                                entries: entries,
                                                workload: workload)

          expected_result = {
            date: '2018-04-11',
            worked_time_in_minutes: 0,
            balance_time_in_minutes: -480,
            entries: [],
            messages: [:absence]
          }

          expect(workday_builder.build).to eq(expected_result)
        end
      end
    end

    context 'out of the working days or in holidays' do
      context 'with entries' do
        it 'doubles the worked time' do
          # future release
        end
      end

      context 'with no entries' do
        it 'does not add absence message nor deducts time' do
          # future release
        end
      end
    end
  end
end
