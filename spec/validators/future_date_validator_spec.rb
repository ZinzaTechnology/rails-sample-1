require "rails_helper"

class FutureDateValidatable
  include ActiveModel::Validations
  attr_accessor :interview_date
  validates :interview_date, future_date: true
end

describe FutureDateValidator do
  subject{FutureDateValidatable.new}

  context "with a valid interview date" do
    it "should be valid" do
      subject.interview_date = Time.current + 1.days
      expect(subject.valid?).to eq true
    end
  end

  context "with a invalid interview_date" do
    it "should be invalid" do
      subject.interview_date = Time.current - 1.hours
      expect(subject.valid?).to eq false
    end
  end
end
