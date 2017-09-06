class ProfilesController < ApplicationController
  before_action :load_profile, only: %i(show edit update)
  before_action :authorize_profile, only: %i(show edit update)

  def show
    @support = ChartSupport.new current_user
  end

  def edit; end

  def update
    if @profile.update(profile_params)
      flash[:success] = t('.success')
      redirect_to profile_path
    else
      flash.now[:danger] = t('.failed')
      render :edit
    end
  end

  private

  def load_profile
    @profile = Profile.find_by(user_id: current_user.id)
  end

  def authorize_profile
    authorize!(params[:action].to_sym, @profile || Profile)
  end

  def profile_params
    params.require(:profile).permit(:given_name, :family_name, :gender, :birth_y, :birth_m, :birth_d, :intern,
      :address, :avatar, :phone, :avatar_cache)
  end
end
