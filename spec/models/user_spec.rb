require "rails_helper"

RSpec.describe User, type: :model do
  describe "relation" do
    it{should have_many :groups}
    it{should have_many :requests}
    it{should belong_to :superior}
  end

  describe "validations" do
    describe "email" do
      subject{FactoryBot.build(:user)}
      it{should validate_uniqueness_of :email}
      it{should validate_presence_of :email}
    end
  end

  describe "check_in_on_today?" do
    subject{FactoryBot.create(:user)}
    context "have not working_time_today" do
      it "should return nil" do
        expect(subject.check_in_on_today?).to eq nil
      end
    end

    context "have working_time_today" do
      let(:current_time){Time.current}
      before do
        FactoryBot.create :working_time, user: subject, check_in: current_time
      end
      it "should return nil" do
        expect(subject.check_in_on_today?.to_date).to eq current_time.to_date
      end
    end
  end

  describe "check_out_on_today?" do
    subject{FactoryBot.create(:user)}
    context "have not working_time_today" do
      it "should return nil" do
        expect(subject.check_out_on_today?).to eq nil
      end
    end

    context "have working_time_today" do
      let(:current_time){Time.current}
      before do
        FactoryBot.create :working_time, user: subject, check_out: current_time
      end
      it "should return nil" do
        expect(subject.check_out_on_today?.to_date).to eq current_time.to_date
      end
    end
  end
end
