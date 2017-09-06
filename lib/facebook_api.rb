class FacebookApi
  def initialize
    @parameters = {}
  end

  def list_pages(access_token, user_id, fields: nil)
    @parameters['access_token'] = access_token
    @parameters['fields'] = fields if fields.present?
    request_url = "https://graph.facebook.com/v8.0/#{user_id}/accounts?#{query_string}"
    result = HTTParty.try(:get, request_url)
    result.parsed_response
  end

  def page_detail(access_token, page_id, fields: nil)
    @parameters['access_token'] = access_token
    @parameters['fields'] = fields if fields.present?
    request_url = "https://graph.facebook.com/v8.0/#{page_id}?#{query_string}"
    result = HTTParty.try(:get, request_url)
    result.parsed_response
  end

  def retrieve_page_reviews(access_token, page_id, fields: nil)
    @parameters['access_token'] = access_token
    @parameters['fields'] = fields if fields.present?
    request_url = "https://graph.facebook.com/v8.0/#{page_id}/ratings?#{query_string}"
    result = HTTParty.try(:get, request_url)
    result.parsed_response
  end

  def fb_page_categories(access_token, locale)
    @parameters['access_token'] = access_token
    @parameters['locale'] = locale
    request_url = "https://graph.facebook.com/v8.0/fb_page_categories?#{query_string}"
    result = HTTParty.try(:get, request_url)
    result.parsed_response
  end

  def update_page_info(access_token, page_id, info_params)
    @parameters['access_token'] = access_token
    request_url = "https://graph.facebook.com/v8.0/#{page_id}?#{query_string}"
    request_body = info_params
    result = HTTParty.post(request_url, :body => request_body.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    result.parsed_response
  end

  private

  def query_string
    @parameters.sort.map do |key, value|
      [URI.escape(key.to_s, Regexp.new('[^#{URI::PATTERN::UNRESERVED}]')),
      URI.escape(value.to_s, Regexp.new('[^#{URI::PATTERN::UNRESERVED}]'))].join('=')
    end.join('&')
  end
end
