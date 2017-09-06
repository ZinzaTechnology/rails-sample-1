class InvitationMailer < ApplicationMailer
  NOTIFY_EMAILS = %w(sample@zinza.com.vn).freeze

  def invite_accepted user_invitation
    @user = user_invitation.user
    @candidate = user_invitation.invitation.candidate
    mail to: @user.email, subject: t('.subject', candidate_name: @candidate.name)
  end

  def invite_interviewer user_invited, invitation
    @user_invited = user_invited
    @candidate = invitation.candidate
    @user_invitation = UserInvitation.find_by(user: user_invited, invitation: invitation)
    mail to: user_invited.email, subject: t('.subject', candidate_name: @candidate.name)
  end

  def send_notification_interviewer interviewer, invitation
    @interviewer = interviewer
    @candidate = invitation.candidate
    @user_invitation = UserInvitation.find_by(user: interviewer, invitation: invitation)
    mail to: interviewer.email, subject: t('.subject', candidate_name: @candidate.name)
  end

  def send_notification_for_hr invitation
    @invitation = invitation
    @candidate = invitation.candidate
    mail to: NOTIFY_EMAILS, subject: t('.subject', candidate_name: @candidate.name)
  end

  def interview_cancel invitation, user_invitation
    @candidate = invitation.candidate
    @invitation = invitation
    @user_invitation = user_invitation
    interviewer = user_invitation.user
    mail to: interviewer.email, subject: t('.subject', candidate_name: @candidate.name)
  end

  def interview_cancel_for_hr invitation
    @candidate = invitation.candidate
    @invitation = invitation
    mail to: NOTIFY_EMAILS, subject: t('.subject', candidate_name: @candidate.name)
  end
end
