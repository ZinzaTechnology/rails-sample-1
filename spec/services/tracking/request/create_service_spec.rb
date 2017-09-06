require "rails_helper"

RSpec.describe Tracking::Request::CreateService, type: :service do
  describe "#perform" do
    let(:user){FactoryBot.create :user}
    let(:service){Tracking::Request::CreateService.new(params, user).perform}
    context "success" do
      context "kind is over_time" do
        let(:params) do
          {
            "kind" => "over_time",
            "content" => "test content",
            "start_at" => Time.current + 1.hours,
            "end_at" => Time.current + 2.hours,
            "phone" => "1234567890",
            "project" => "wsm"
          }
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("requests.create.success")
          expect(service[:resource].persisted?).to be true
        end
      end

      context "kind is days_off" do
        let(:params) do
          {
            "kind" => "days_off",
            "content" => "test content",
            "start_at" => Time.current + 1.hours,
            "end_at" => Time.current + 2.hours,
            "phone" => "1234567890",
            "project" => "wsm"
          }
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("requests.create.success")
          expect(service[:resource].persisted?).to be true
        end
      end
    end

    context "failed" do
      context "kind is over_time" do
        let(:params) do
          {
            "kind" => "over_time"
          }
        end
        it "should return false" do
          expect(service[:success]).to eq false
          expect(service[:message]).to eq I18n.t("requests.create.failed", item: Request.model_name.human)
        end
      end

      context "kind is days_off" do
        let(:params) do
          {
            "kind" => "days_off"
          }
        end
        it "should return false" do
          expect(service[:success]).to eq false
          expect(service[:message]).to eq I18n.t("requests.create.failed", item: Request.model_name.human)
        end
      end
    end
  end
end
