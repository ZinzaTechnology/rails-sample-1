require "rails_helper"

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe ProfilesController, type: :controller do
  describe "GET #show" do
    context "user logged in" do
      let(:profile){FactoryBot.create :profile}
      before do
        login profile.user
        get :show, params: {id: 1}
      end

      it "should respone status 200" do
        expect(response).to have_http_status 200
      end
    end

    context "user not logged in" do
      before do
        get :show, params: {id: 1}
      end
      it_behaves_like "require login"
    end
  end

  describe "GET #edit" do
    context "user not logged in" do
      before do
        get :edit, params: {id: 1}
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let(:profile){FactoryBot.create :profile}
      before do
        login profile.user
        get :edit, params: {id: profile.id}
      end

      it "should render edit" do
        expect(assigns(:profile)).to eq(profile)
        expect(response).to have_http_status 200
      end
    end
  end

  describe "PUT #update" do
    context "user not logged in" do
      before do
        put :update, params: {id: 1}
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let(:user){FactoryBot.create :user}
      let(:profile){FactoryBot.create(:profile, user_id: user.id)}
      let(:profile1){FactoryBot.create(:profile, user_id: user.id)}
      before do
        login profile.user
        put :update, params: params
      end

      context "invalid params" do
        let(:params) do
          {
            id: profile1.id,
            profile: {
              given_name: "",
              birth_y: ""
            }
          }
        end
        it "should not update user" do
          expect(flash[:danger]).to eq I18n.t("profiles.update.failed")
          expect(response).to render_template :edit
          expect do
            profile.reload
          end.to not_change(profile, :birth_y)
        end
      end

      context "valid params" do
        let(:params) do
          {
            id: profile.id,
            profile: {
              birth_m: "12",
              birth_y: "1999",
              birth_d: "13",
              gender: "male"
            }
          }
        end
        it "should update user" do
          expect(flash[:success]).to eq I18n.t("profiles.update.success")
          expect(response).to redirect_to profile_path
        end
      end
    end
  end
end
