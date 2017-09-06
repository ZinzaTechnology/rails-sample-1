class StaticPagesController < ApplicationController
  layout :dynamic_layout
  skip_before_action :require_login
  skip_authorize_resource

  def home; end

  private

  def dynamic_layout
    user_signed_in? ? 'application' : 'devise'
  end
end
