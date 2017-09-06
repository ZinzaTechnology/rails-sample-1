class ApplicationController < ActionController::Base
  before_action :basic_authenticate

  rescue_from StandardError do |e|
    Rails.logger.error e.message
    send_to_slack(e.message) if Rails.env.production?
    render "errors/server_errors", layout: false
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path
  end

  rescue_from CanCan::AccessDenied do
    flash[:danger] = t("error.access_denied")
    redirect_to root_url
  end

  private

  def basic_authenticate
    return unless Rails.env.staging?
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def send_to_slack message
    uri = URI.parse(ENV['SLACK_HOOK'])
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.max_retries = 0
    request = Net::HTTP::Post.new(uri)
    request.body = slack_body(message)
    https.request(request)
  end
end
