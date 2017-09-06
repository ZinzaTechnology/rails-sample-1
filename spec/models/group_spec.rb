require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "relation" do
    it{should have_many :users}
    it{should have_many :user_groups}
    it{should have_many :group_permissions}
    it{should have_many :permissions}
  end

  describe "validations" do
    describe "name" do
      subject{FactoryBot.build(:group)}
      it{should validate_uniqueness_of :name}
      it{should validate_presence_of :name}
    end
  end
end
