require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe CandidatesController, type: :controller do
  describe "GET #index" do
    context "user not logged in" do
      before do
        get :index
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let!(:candidates){FactoryBot.create_list :candidate, 2}
      let(:user){FactoryBot.create :user}
      before do
        allow(user).to receive(:permissions){["read_candidate"]}
        login user
        get :index
      end
      context "without search params" do
        it "should render index" do
          expect(assigns(:candidates).size).to eq 2
          expect(response).to have_http_status 200
        end
      end
    end
  end

  describe "GET #show" do
    context "user not logged in" do
      before do
        get :show, params: {id: 1}
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let(:user){FactoryBot.create :user}
      let(:candidate){FactoryBot.create :candidate}
      before do
        allow(user).to receive(:permissions){["read_candidate"]}
        login user
        get :show, params: {id: candidate.id}
      end

      it "should render new" do
        expect(assigns(:candidate)).to eq(candidate)
        expect(response).to have_http_status 200
      end
    end
  end

  describe "GET #new" do
    context "user not logged in" do
      before do
        get :new
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let(:user){FactoryBot.create :user}
      before do
        allow(user).to receive(:permissions){["modify_candidate"]}
        login user
        get :new
      end

      it "should render new" do
        expect(response).to have_http_status 200
      end
    end
  end

  describe "POST #create" do
    context "user not logged in" do
      before do
        post :create
      end
      it_behaves_like "require login"
    end

    context "user logged in" do
      let(:user){FactoryBot.create :user}
      let(:personal_skill){PersonalSkill.create(name: "test")}
      params_file = {file: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
        "/spec/fixtures/test-file.pdf")))}
      before do
        allow(user).to receive(:permissions){["modify_candidate"]}
        login user
      end

      context "valid name" do
        let(:params) do
          {
            candidate: {
              name: "test",
              personal_skill_ids: [personal_skill.id],
              candidate_emails_attributes: {
                0 => {
                  email: "test@gmail.com"
                }
              },
              candidate_phones_attributes: {
                0 => {
                  phone: "1234567890"
                }
              },
              candidate_attachments_attributes: {
                0 => params_file
              }
            }
          }
        end
        before{post :create, params: params}
        it "should create new candidate" do
          expect(assigns(:candidate).persisted?).to be true
          expect(assigns(:candidate).personal_skills.size).to eq 1
          expect(response).to redirect_to candidate_path(assigns(:candidate))
          expect(flash[:success]).to eq I18n.t("candidates.create.success")
        end
      end

      context "invalid name" do
        let(:params) do
          {
            candidate: {
              name: nil,
              candidate_attachments_attributes: {
                0 => {
                  _destroy: "false"
                }
              }
            }
          }
        end
        before{post :create, params: params}
        it "re-renders the new and shows flash message" do
          expect(assigns(:candidate).persisted?).to be false
          expect(response).to render_template :new
          expect(flash[:danger]).to eq I18n.t("candidates.create.failed", item: Candidate.model_name.human)
        end
      end
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
      let(:candidate){FactoryBot.create :candidate}
      let(:user){FactoryBot.create :user}
      before do
        allow(user).to receive(:permissions){["modify_candidate"]}
        login user
        get :edit, params: {id: candidate.id}
      end

      it "should render edit" do
        expect(assigns(:candidate)).to eq(candidate)
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
      let(:candidate){FactoryBot.create :candidate}
      let(:user){FactoryBot.create :user}
      params_file = {file: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
        "/spec/fixtures/test-file.pdf")))}
      before do
        allow(user).to receive(:permissions){["modify_candidate"]}
        login user
        put :update, params: params
      end

      context "invalid params name" do
        let(:params) do
          {
            id: candidate.id,
            candidate: {
              name: nil,
              candidate_emails_attributes: {
                0 => {
                  email: "test@gmail.com"
                }
              },
              candidate_phones_attributes: {
                0 => {
                  phone: "1234567890"
                }
              },
              candidate_attachments_attributes: {
                0 => params_file
              }
            }
          }
        end
        it "should not update candidate" do
          expect(response).to have_http_status 200
          expect(flash[:danger]).to eq I18n.t("candidates.update.failed", item: candidate.model_name.human)
          expect(response).to render_template :edit
          expect do
            candidate.reload
          end.to not_change(candidate, :name)
        end
      end

      context "valid params" do
        params_file = {file: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,
          "/spec/fixtures/test-file.pdf")))}
        let(:params) do
          {
            id: candidate.id,
            candidate: {
              name: "valid name",
              candidate_emails_attributes: {
                0 => {
                  email: "test@gmail.com"
                }
              },
              candidate_phones_attributes: {
                0 => {
                  phone: "1234567890"
                }
              },
              candidate_attachments_attributes: {
                0 => params_file
              }
            }
          }
        end
        it "should update candidate" do
          expect(flash[:success]).to eq I18n.t("candidates.update.success")
          expect(response).to redirect_to candidate_path(candidate)
          expect do
            candidate.reload
          end.to change(candidate, :name).to("valid name")
        end
      end
    end
  end
end
