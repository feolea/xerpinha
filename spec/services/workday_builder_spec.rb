# frozen_string_literal: true

RSpec.describe Services::WorkdayBuilder do
  describe '#build' do
    context 'within working days' do
      context 'without interval rest' do
      end

      context 'with interval rest' do
        context 'and left time of interval' do
          context 'and more than 50% of journey' do
            it 'adds the time left to balance time' do
            end
          end

          context 'and less than 50% of daily journey' do
            it 'does not add time left to balance time' do
            end
          end
        end

        context 'and exactly time of interval' do
          it 'does not add nor deduct time' do
          end
        end

        context 'and one or more minutes of interval' do
          it 'adds exceeded_interval message but does not deduct time' do
          end
        end
      end

      context 'with odd entries' do
        it 'adds missing_entry message and do not add nor deduct time' do
        end
      end

      context 'with no entries' do
        it 'adds absence message' do
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
        end
      end
    end
  end
end
