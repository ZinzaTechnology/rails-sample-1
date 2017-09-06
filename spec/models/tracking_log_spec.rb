require "rails_helper"

RSpec.describe TrackingLog, type: :model do
  describe "relation" do
    it{should belong_to :resource}
    it{should belong_to(:owner).class_name User.name}
  end
end
