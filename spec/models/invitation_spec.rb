require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "relation" do
    it{should belong_to :candidate}
  end

  describe "validations" do
    subject{FactoryBot.build(:invitation)}
    it{should validate_presence_of :interview_date}
    it{should validate_presence_of :room}
  end
end
