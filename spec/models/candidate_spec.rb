require "rails_helper"

RSpec.describe Candidate, type: :model do
  describe "relation" do
    it{should have_many :personal_skills}
    it{should have_many :invitations}
  end

  describe "validations" do
    describe "name" do
      subject{FactoryBot.build(:candidate)}
      it{should validate_presence_of :name}
    end
  end
end
