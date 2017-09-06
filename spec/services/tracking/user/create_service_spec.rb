require "rails_helper"

RSpec.describe Tracking::User::CreateService, type: :service do
  describe "#perform" do
    let(:service){Tracking::User::CreateService.new(params, current_user).perform}
    let(:current_user){FactoryBot.build :user}

    context "success" do
      context "position not intern" do
        let(:params) do
          {
            email: "tuanvhtest@zinza.com.vn",
            profile_attributes: {
              given_name: "given name",
              family_name: "family name",
              birth_d: "13",
              birth_m: "06",
              birth_y: "1999",
              intern: false
            }
          }
        end
        before do
          allow(Gsuite::User::CreateUserJob).to receive_message_chain(:perform_async).with(anything).and_return true
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("users.create.success")
          expect(service[:resource].persisted?).to be true
        end
      end

      context "position intern" do
        let(:params) do
          {
            email: "tuanvhtest@gmail.com.vn",
            profile_attributes: {
              given_name: "given name",
              family_name: "family name",
              birth_d: "13",
              birth_m: "06",
              birth_y: "1999",
              intern: true
            }
          }
        end
        before do
          allow(Gsuite::User::CreateUserJob).to receive_message_chain(:perform_async).with(anything).and_return true
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("users.create.success")
          expect(service[:resource].persisted?).to be true
        end
      end
    end

    context "failed" do
      context "invalid email" do
        let(:params) do
          {
            email: "tuanvhtest"
          }
        end
        it "should return false" do
          expect(service[:success]).to eq false
          expect(service[:message]).to eq I18n.t("users.create.failed", item: User.model_name.human)
        end
      end

      context "invalid email with user not intern" do
        let(:params) do
          {
            email: "tuanvhtest@gmail.com.vn",
            profile_attributes: {
              given_name: "given name",
              family_name: "family name",
              position: "member"
            }
          }
        end
        it "should return false" do
          expect(service[:success]).to eq false
          expect(service[:message]).to eq I18n.t("users.create.failed", item: User.model_name.human)
        end
      end
    end
  end
end
