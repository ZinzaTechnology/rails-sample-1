require "rails_helper"

RSpec.describe Api::V1::ImportCsvService, type: :service do
  describe "#perform" do
    let(:service){ImportCsvService.new table_name, csv_path, false}
    let(:table_name){"permissions"}

    context "valid csv file" do
      let(:csv_path){Rails.root.join "spec", "fixtures", "permissions.csv"}

      it "import success" do
        expect{service.perform}.to change {Permission.count}.by(1)
      end
    end

    context "invalid csv file" do
      let(:csv_path){Rails.root.join "spec", "fixtures", "permissions_error.csv"}

      it "import failed" do
        expect{service.perform}.to change {Permission.count}.by(0)
      end
    end
  end
end
