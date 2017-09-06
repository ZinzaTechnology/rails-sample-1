require "rails_helper"

class CheckinPerDayValidatable
  include ActiveModel::Validations
  attr_accessor :check_in, :user_id
  validates :check_in, checkin_per_day: true
end

describe CheckinPerDayValidator do
  let(:user){FactoryBot.create(:user)}
  context "with a valid check_in" do
    subject{CheckinPerDayValidatable.new}
    it "should be valid" do
      subject.user_id = user.id
      subject.check_in = Time.current
      expect(subject.valid?).to eq true
    end
  end

  context "with a invalid email" do
    before do
      FactoryBot.create(:working_time, user: user, check_in: Time.current, check_out: nil)
    end
    subject{CheckinPerDayValidatable.new}
    it "should be invalid" do
      subject.user_id = user.id
      subject.check_in = Time.current
      expect(subject.valid?).to eq false
    end
  end
end
