require "rails_helper"

RSpec.describe Tracking::Request::UpdateService, type: :service do
  describe "#perform" do
    let(:user){FactoryBot.create :user}
    let(:service){Tracking::Request::UpdateService.new(request_test, params, user).perform}

    context "success" do
      let(:request_test){FactoryBot.create :request, user_id: user.id, status: :pending}
      let(:params) do
        {status: "approved"}
      end
      it "should return success" do
        expect(service[:success]).to eq true
        expect(service[:message]).to eq I18n.t("requests.update.success")
        expect(request_test.status). to eq "approved"
      end
    end

    context "failed" do
      let(:request_test){FactoryBot.create :request, user_id: user.id, status: :approved}
      let(:params) do
        {status: "declined"}
      end
      it "should return false" do
        expect(service[:success]).to eq false
        expect(service[:message]).to eq I18n.t("requests.update.failed")
        expect(request_test.status). to eq "approved"
      end
    end
  end
end
