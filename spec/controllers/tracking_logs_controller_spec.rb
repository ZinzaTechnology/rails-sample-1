require "rails_helper"

RSpec.describe TrackingLogsController, type: :controller do
  describe "GET #index" do
    context "user not logged in" do
      before do
        get :index
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let!(:user){FactoryBot.create :user}
      let!(:request){FactoryBot.create :request, user_id: user.id}
      let!(:tracking_logs){FactoryBot.create_list :tracking_log, 3, resource: request, owner_id: user.id}

      before do
        allow(user).to receive(:permissions){["index_tracking_log"]}
        login user
        get :index
      end
      it "should render index" do
        expect(assigns(:tracking_logs).size).to eq 3
        expect(response).to have_http_status 200
      end
    end
  end
end
