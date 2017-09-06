require "rails_helper"

RSpec.describe CalendarHelper, type: :helper do
  describe "#time_status" do
    context "time is not present" do
      let(:time){nil}
      it "return nothing" do
        expect(helper.time_status(time, :checkin)).to be_nil
      end
    end

    context "time is present" do
      context "time is correct" do
        let(:time){"07:00"}
        it "return passed" do
          expect(helper.time_status(time, :checkin)).to eq(:green_border)
        end
      end

      context "time is wrong" do
        let(:time){"11:00"}
        it "return failed" do
          expect(helper.time_status(time, :checkin)).to eq(:red_border)
        end
      end
    end
  end
end
