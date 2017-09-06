require "rails_helper"

RSpec.describe Api::V1::ImportWorkingTimesService, type: :service do
  describe "#perform" do
    let(:user){FactoryBot.create :user}
    let(:service){Api::V1::ImportWorkingTimesService.new(params).perform}

    context "valid params" do
      let(:params) do
        ActionController::Parameters.new(
          {
            "data" => [
              {
                "email" => user.email,
                "check_in" => "2019/10/28 8:00",
                "check_out" => "2019/10/28 18:00"
              }
            ]
          }
        )
      end

      it "import users working times" do
        expect(service[:success]).to be true
        expect(user.working_times.count).to eq 1
      end
    end

    context "invalid params" do
      let(:params) do
        ActionController::Parameters.new(
          {
            "invalid_data" => [
              {
                "email" => user.email,
                "check_in" => "2019/10/28 8:00",
                "check_out" => "2019/10/28 18:00"
              }
            ]
          }
        )
      end

      it "can't import users working times" do
        expect(service[:success]).to be false
      end
    end
  end
end
