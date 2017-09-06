require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  let!(:user){FactoryBot.create :user}
  let!(:invitation){FactoryBot.create :invitation}
  let!(:user_invitation){FactoryBot.create :user_invitation, user_id: user.id, invitation_id: invitation.id}

  describe "#invite_accepted" do
    let(:mail){InvitationMailer.invite_accepted(user_invitation)}
    it "renders the headers" do
      expect(mail.to).to eq([user.email])
    end
  end

  describe "#invite_interviewer" do
    let(:mail){InvitationMailer.invite_interviewer(user, invitation)}
    it "renders the headers" do
      expect(mail.to).to eq([user.email])
    end
  end

  describe "#send_notification_interviewer" do
    let(:mail){InvitationMailer.send_notification_interviewer(user, invitation)}
    it "renders the headers" do
      expect(mail.to).to eq([user.email])
    end
  end
end
