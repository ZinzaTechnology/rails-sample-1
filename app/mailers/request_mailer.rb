class RequestMailer < ApplicationMailer
  def registration user_superior, request
    @user = request.owner
    @user_superior = user_superior
    @request = request
    mail(to: user_superior.email, subject: t('.subject', user_full_name: @user.full_name,
      over_time_or_day_off: request.kind_text))
  end

  def confirmation handler, request
    @handler = handler
    @request = request
    mail(to: request.owner_email, subject: t('.subject', handler_full_name: handler.full_name,
      over_time_or_day_off: request.kind_text))
  end

  def registration_for_hr request
    @user = request.owner
    @request = request
    mail(to: 'sample@zinza.com.vn', subject: t('.subject', user_full_name: @user.full_name,
      over_time_or_day_off: request.kind_text))
  end
end
