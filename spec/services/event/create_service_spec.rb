require "rails_helper"

RSpec.describe Event::CreateService, type: :service do
  describe "#perform" do
    let(:service){Event::CreateService.new(Event.new(params)).perform}
    context "success" do
      context "create event" do
        let(:params) do
          {
            name: 'Holiday',
            start_at: Time.zone.now + 1.days,
            end_at: Time.zone.now + 2.days,
            is_holiday: true
          }
        end
        before do
          FactoryBot.create :day, date: params[:start_at]
          FactoryBot.create :day, date: params[:end_at]
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("events.create.success")
        end
      end
    end

    context "failed" do
      context "invalid params" do
        let(:params) do
          {
            name: '',
            start_at: '',
            end_at: '',
            is_holiday: true
          }
        end
        it "should return success" do
          expect(service[:success]).to eq false
          expect(service[:message]).to eq I18n.t("events.create.failed")
        end
      end
    end
  end
end
