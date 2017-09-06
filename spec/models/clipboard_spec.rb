require "rails_helper"

RSpec.describe Clipboard, type: :model do
  describe "validations" do
    it{should validate_presence_of :content}
  end
end
