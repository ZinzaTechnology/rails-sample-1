require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  ALL_PERMISSIONS = %w(read_user modify_user read_group modify_group read_candidate
    modify_candidate read_request).freeze

  subject{Ability.new(user)}
  let(:user){FactoryBot.create :user}

  context "user has no permissions" do
    it{should be_able_to :index, WorkingTime}
    it{should be_able_to :show, Profile}
    it{should be_able_to :create, Request}
    it{should_not be_able_to :read, User}
    it{should_not be_able_to :modify, User}
    it{should_not be_able_to :read, Group}
    it{should_not be_able_to :modify, Group}
    it{should_not be_able_to :read, Candidate}
    it{should_not be_able_to :modify, Candidate}
    it{should_not be_able_to :read, Request}
  end

  context "user has all permissions" do
    before do
      allow(user).to receive(:permissions){ALL_PERMISSIONS}
    end

    it{should be_able_to :index, WorkingTime}
    it{should be_able_to :show, Profile}
    it{should be_able_to :read, User}
    it{should be_able_to :modify, User}
    it{should be_able_to :read, Group}
    it{should be_able_to :modify, Group}
    it{should be_able_to :read, Candidate}
    it{should be_able_to :modify, Candidate}
    it{should be_able_to :read, Request}
  end

  context "superior permission" do
    subject{Ability.new(user)}
    let(:user){FactoryBot.create :user}
    let(:member){FactoryBot.create :user, superior_id: user.id}
    let(:request){FactoryBot.create :request, user_id: member.id}
    it{should be_able_to :update, Request}
  end
end
