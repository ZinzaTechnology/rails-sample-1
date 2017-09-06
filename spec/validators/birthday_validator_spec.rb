require "rails_helper"

class BirthdayValidatable
  include ActiveModel::Validations
  attr_accessor :birth_y, :birth_m, :birth_d, :birthday
  validates :birthday, birthday: true
end

describe EndAtDatetimeValidator do
  subject{BirthdayValidatable.new}

  context "with a valid birthday" do
    it "should be valid" do
      subject.birth_y = "2020"
      subject.birth_m = "1"
      subject.birth_d = "1"
      expect(subject.valid?).to eq true
    end
  end

  context "with a invalid birthday" do
    it "should be invalid" do
      subject.birth_y = "2020"
      subject.birth_m = "13"
      subject.birth_d = "13"
      expect(subject.valid?).to eq false
    end
  end
end
