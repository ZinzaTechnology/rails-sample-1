# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_SENDER_ADDRESS', 'noreply@sample.com')
  layout 'mailer'

  protected

  def filter_emails(emails)
    emails = [emails].flatten.compact
    blacklist_emails = SesBlacklistEmail.where(email: emails).pluck(:email)
    emails - blacklist_emails
  end
end
