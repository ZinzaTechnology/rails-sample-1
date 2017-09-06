require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home" do
    before do
      get :home
    end

    it "should return success" do
      expect(response).to have_http_status 200
    end
  end
end
