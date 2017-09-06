require "rails_helper"

RSpec.describe TrackingLogHelper, type: :helper do
  describe "#link_to_owner" do
    context "should be return a link" do
      let!(:user){FactoryBot.create :user}
      let!(:request){FactoryBot.create :request, user_id: user.id}
      let!(:tracking_log){FactoryBot.build :tracking_log, resource: request, owner_id: user.id}

      let(:expected_result){link_to(user.email, user_path(user), class: 'pr-2', target: '_blank')}
      it {expect(helper.link_to_owner(tracking_log)).to eq expected_result}
    end

    context "should be return a text" do
      let!(:tracking_log){FactoryBot.build :tracking_log}

      it {expect(helper.link_to_owner(tracking_log)).to eq tracking_log.owner_id}
    end
  end

  describe "#link_to_resource" do
    context "should be return a link" do
      let!(:user){FactoryBot.create :user}
      let!(:request){FactoryBot.create :request, user_id: user.id}
      let!(:tracking_log){FactoryBot.build :tracking_log, resource: request, owner_id: user.id}

      let(:expected_result){link_to(request.id, request_path(request), target: '_blank')}
      it {expect(helper.link_to_resource(tracking_log)).to eq expected_result}
    end

    context "should be return a text" do
      let!(:tracking_log){FactoryBot.build :tracking_log}

      it {expect(helper.link_to_resource(tracking_log)).to eq tracking_log.resource_id}
    end
  end
end
