class Ability
  include CanCan::Ability
  attr_accessor :user

  def initialize user
    @user = user
    alias_action :update, :create, :destroy, to: :modify

    common_permission
    # NOTE: Important part deleted for sample app
    recruitment_permission
  end

  private

  def common_permission
    can :index, WorkingTime
    can [:show, :edit, :update], Profile, user_id: user.id
    can :create, Request
    can :show, Request do |request|
      request.user_id == user.id
    end
  end

  def recruitment_permission
    can [:show, :update], UserInvitation, user_id: user.id
    can :show, Candidate do |candidate|
      candidate.user_invitations.pluck(:user_id).include? user.id
    end
    can [:new, :create], Interview do |interview|
      interview.user_invitation.create_interview?
    end
    interview_permission
  end

  def interview_permission
    can [:show, :update], Interview do |interview|
      interview.user.id == user.id
    end
  end
end
