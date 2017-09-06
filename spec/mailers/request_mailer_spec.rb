require "rails_helper"

RSpec.describe RequestMailer, type: :mailer do
  let!(:superior){FactoryBot.create :user}
  let!(:user){FactoryBot.create :user, superior_id: superior.id}
  let!(:request){FactoryBot.create :request, user_id: user.id}

  describe "#registration" do
    let(:mail){RequestMailer.registration(superior, request)}
    it "renders the headers" do
      expect(mail.to).to eq([superior.email])
    end
  end

  describe "#confirmation" do
    let(:mail){RequestMailer.confirmation(superior, request)}
    it "renders the headers" do
      expect(mail.to).to eq([user.email])
    end
  end

  describe "#registration for hr" do
    let(:mail){RequestMailer.registration_for_hr(request)}
    it "renders the headers" do
      expect(mail.to).to eq(['sample@zinza.com.vn'])
    end
  end
end
