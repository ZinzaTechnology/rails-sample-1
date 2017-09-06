require 'google/api_client/client_secrets'

class GoogleBusinessApi
  attr_reader :parameters, :google_token, :account_id, :authorization, :refresh_token

  def initialize(options={})
    @account_id = options[:google_account_id]
    @refresh_token = options[:google_account_refresh_token]
    raise 'Google Token NotFound' if @account_id.blank?
    @base_url = "https://mybusiness.googleapis.com/v4/accounts/#{@account_id}"
    @parameters = {}
    @parameters['access_token'] = google_access_token
  end

  def list_locations(page_token)
    @parameters['pageToken'] = page_token if page_token.present?
    request_url = @base_url + '/locations?' + query_string
    result = HTTParty.try :get, request_url
    result.parsed_response
  end

  def get_location(location_id)
    request_url = "#{@base_url}/locations/#{location_id}?#{query_string}"
    result = HTTParty.try :get, request_url
    result.parsed_response
  end

  def list_reviews(location_id, page_token)
    @parameters['pageToken'] = page_token if page_token.present?
    request_url = @base_url + "/locations/#{location_id}/reviews?" + query_string
    result = HTTParty.try :get, request_url
    result.parsed_response
  end

  def list_reviews_batch(location_ids, page_token)
    request_url = @base_url + "/locations:batchGetReviews?" + query_string
    locationNames = []
    location_ids.each{|location_id| locationNames << "accounts/#{@account_id}/locations/#{location_id}" }

    request_body = {
      "locationNames": locationNames,
      "pageSize": 4000,
      "pageToken": page_token
    }

    result = HTTParty.post(request_url, :body => request_body.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    result.parsed_response
  end

  def get_all_posts(location_id, page_token)
    @parameters['pageToken'] = page_token if page_token.present?
    request_url = @base_url + "/locations/#{location_id}/localPosts/?" + query_string
    result = HTTParty.get(request_url, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    result.parsed_response
  end

  def get_google_updated_info(location_id)
    request_url = "#{@base_url}/locations/#{location_id}:googleUpdated?#{query_string}"
    result = HTTParty.try :get, request_url
    result.parsed_response
  end

  def list_categories(search_term: nil, page_token: nil, page_size: nil)
    @parameters['regionCode'] = 'JP'
    @parameters['languageCode'] = 'ja'
    @parameters['searchTerm'] = search_term if search_term.present?
    @parameters['pageToken'] = page_token if page_token.present?
    @parameters['pageSize'] = page_size if page_size.present?
    request_url = "https://mybusiness.googleapis.com/v4/categories?#{query_string}"
    result = HTTParty.try :get, request_url
    result.parsed_response
  end

  def list_media(location_id, page_token)
    @parameters['pageToken'] = page_token if page_token.present?
    request_url = "#{@base_url}/locations/#{location_id}/media?#{query_string}"
    result = HTTParty.try :get, request_url
    result.parsed_response
  end

  class << self
    def error_message(response_error)
      if response_error['details'].present?
        response_error['details'].map do |detail|
          detail['errorDetails'].map do |error_detail|
            error_detail['message']
          end
        end.flatten.join('\n')
      else
        response_error['message']
      end
    end
  end

  private

  def google_access_token
    secret = Google::APIClient::ClientSecrets.new(
      { 'web' =>
        {
          'refresh_token' => @refresh_token,
          'client_id' => ENV['GOOGLE_CLIENT_ID'],
          'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
        }
      }
    )
    @authorization = secret.to_authorization
    @authorization.refresh!
    @authorization.access_token
  end

  def query_string
    if @authorization.expired?
      @authorization.refresh!
      @parameters['access_token'] = @authorization.access_token
    end
    @parameters.sort.map do |key, value|
      [URI.escape(key.to_s, Regexp.new('[^#{URI::PATTERN::UNRESERVED}]')),
      URI.escape(value.to_s, Regexp.new('[^#{URI::PATTERN::UNRESERVED}]'))].join('=')
    end.join('&')
  end
end
