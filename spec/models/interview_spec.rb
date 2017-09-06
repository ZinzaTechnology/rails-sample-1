require 'rails_helper'

RSpec.describe Interview, type: :model do
  describe "relation" do
    it{should belong_to :user_invitation}
  end

  describe "validations" do
    subject do
      FactoryBot.build :interview
    end
    it{should validate_presence_of :status}
    it{should validate_presence_of :evaluate}
  end
end
