class SesMailer < ApplicationMailer
  def bounce_email_notify(new_emails)
    @new_emails = new_emails
    mail(
      to: filter_emails(["test@test.com"]),
      subject: "SES Bounce mail notification"
    )
  end
end
