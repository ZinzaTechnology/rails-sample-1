# frozen_string_literal: true

module ControllerMacros
  def login_user(role = 'user', plan = nil)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = FactoryBot.create(:user, role: role)
      sign_in @current_user
    end
  end
end
