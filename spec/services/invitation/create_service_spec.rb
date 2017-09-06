require "rails_helper"

RSpec.describe Invitation::CreateService, type: :service do
  describe "#perform" do
    let(:user){FactoryBot.create :user}
    let(:candidate){FactoryBot.create :candidate}
    let(:user_invitation){FactoryBot.create :user_invitation}
    let(:service){Invitation::CreateService.new(candidate.invitations.new(params), user).perform}
    context "success" do    
      before{allow(Invitation::InterviewingStatusJob).to receive(:perform_at).and_return(true)}

      context "create invitation" do
        let(:params) do
          {
            room: "over_time",
            interview_date: Time.current + 1.hours,
            user_list: [user.id]
          }
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("invitations.create.success")
        end
      end

      context "create invitation and create user alias" do
        let(:params) do
          {
            room: "over_time",
            interview_date: Time.current + 1.hours,
            user_list: [user.id],
            used_alias: 1,
            alias_name: 'test'
          }
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("invitations.create.success")
          expect(UserAlias.last.name).to eq 'test'
          expect(UserAlias.last.list_user_id).to eq [user.id].to_s
        end
      end

      context "create invitation and update user alias" do
        let!(:user_2){FactoryBot.create :user}
        let!(:user_alias){FactoryBot.create :user_alias, list_user_id: [user_2.id], name: 'test'}
        let(:params) do
          {
            room: "over_time",
            interview_date: Time.current + 1.hours,
            user_list: [user.id],
            used_alias: 1,
            alias_name: 'test'
          }
        end
        it "should return success" do
          expect(service[:success]).to eq true
          expect(service[:message]).to eq I18n.t("invitations.create.success")
          expect(UserAlias.last.name).to eq 'test'
          expect(UserAlias.last.list_user_id).to eq [user.id].to_s
        end
      end
    end

    context "failed" do
      context "invalid params" do
        let(:params) do
          {
            room: "",
            interview_date: "",
            user_list: [],
            alias_name: ''
          }
        end
        it "should return success" do
          expect(service[:success]).to eq false
          expect(service[:message]).to eq I18n.t("invitations.create.failed")
        end
      end
    end
  end
end
