require "rails_helper"

class NotAllowPastDayValidatable
  include ActiveModel::Validations
  attr_accessor :start_at
  validates :start_at, not_allow_past_day: true
end

describe NotAllowPastDayValidator do
  subject{NotAllowPastDayValidatable.new}

  context "with a valid start_at" do
    it "should be valid" do
      subject.start_at = Time.current + 1.hours
      expect(subject.valid?).to eq true
    end
  end

  context "with a invalid start_at" do
    it "should be invalid" do
      subject.start_at = Time.current - 1.hours
      expect(subject.valid?).to eq false
    end
  end
end
