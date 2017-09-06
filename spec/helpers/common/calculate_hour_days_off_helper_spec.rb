require "rails_helper"

RSpec.describe Common::CalculateHourDaysOffHelper, type: :helper do
  context 'same period' do
    context 'hour start_at less than hour end_at in morning' do
      let!(:time) do
        {
          start: '2020/09/10 09:30 +0700'.to_datetime,
          end: '2020/09/10 11:30 +0700'.to_datetime
        }
      end
      let!(:expected_result){2}
      it 'return true' do
        expect(helper.calculate_time_off(time[:start], time[:end])).to eq expected_result
      end
    end

    context 'hour start_at lager than hour end_at in afternoon' do
      let!(:time) do
        {
          start: '2020/09/10 18:30 +0700'.to_datetime,
          end: '2020/09/11 18:00 +0700'.to_datetime
        }
      end
      let!(:expected_result){8}
      it 'return true' do
        expect(helper.calculate_time_off(time[:start], time[:end])).to eq expected_result
      end
    end
  end

  context 'not same period' do
    context 'start_at in morning and end_at in afternoon' do
      let!(:time) do
        {
          start: '2020/09/10 9:30 +0700'.to_datetime,
          end: '2020/09/11 17:30 +0700'.to_datetime
        }
      end
      let!(:expected_result){15}
      it 'return true' do
        expect(helper.calculate_time_off(time[:start], time[:end])).to eq expected_result
      end
    end

    context 'start_at in afternoon and end_at in morning' do
      let!(:time) do
        {
          start: '2020/09/07 17:00 +0700'.to_datetime,
          end: '2020/09/09 9:30 +0700'.to_datetime
        }
      end
      let!(:expected_result){9.5}
      it 'return true' do
        expect(helper.calculate_time_off(time[:start], time[:end])).to eq expected_result
      end
    end
  end

  context 'request include holiday' do
    context 'start_at in morning and end_at in afternoon' do
      let!(:time) do
        {
          start: '2020/09/01 9:30 +0700'.to_datetime,
          end: '2020/09/03 14:00 +0700'.to_datetime
        }
      end
      let!(:expected_result){11.5}
      it 'return true' do
        expect(helper.calculate_time_off(time[:start], time[:end])).to eq expected_result
      end
    end

    context 'start_at in afternoon and end_at in morning' do
      let!(:holiday){FactoryBot.create :event, start_at: '2021/09/03'.to_datetime, is_holiday: true}
      let!(:time) do
        {
          start: '2021/09/02 9:00 +0700'.to_datetime,
          end: '2021/09/03 10:00 +0700'.to_datetime
        }
      end
      let!(:expected_result){0}
      it 'return true' do
        expect(helper.calculate_time_off(time[:start], time[:end])).to eq expected_result
      end
    end
  end
end
