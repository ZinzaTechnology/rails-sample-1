require 'rails_helper'

RSpec.describe GroupPermission, type: :model do
  describe "relation" do
    it{should belong_to :permission}
    it{should belong_to :group}
  end
end
