require 'google/api_client/client_secrets'
require 'google/apis/analytics_v3'
require 'google/apis/analyticsreporting_v4'

class GoogleAnalyticApi
  def initialize(options={})
    @refresh_token = options[:google_account_refresh_token]
    @access_token = google_access_token
  end

  def get_ga_data view_id
    profile_id = "ga:#{view_id}"
    start_date = '30daysAgo'
    end_date = 'yesterday'
    metrics = 'ga:sessions, ga:users'

    @service = analytic_service
    @service.get_ga_data(profile_id, start_date, end_date, metrics, {
      dimensions: 'ga:date'
    })
  end

  def get_goal_data view_id, date_range, goal_option, segments
    analytics_reporting_service
    segments = segments.map{ |item| { segment_id: item } }
    date_range = date_range.delete(' ').split('-')
    date_range = @analytics::DateRange.new(start_date: date_range[0].gsub('/', '-'), end_date: date_range[1].gsub('/', '-'))
    dimension_date = @analytics::Dimension.new(name: 'ga:date')
    dimension_goal_completion = @analytics::Dimension.new(name: 'ga:goalCompletionLocation')
    dimension_goal_previos_step_1 = @analytics::Dimension.new(name: 'ga:goalPreviousStep1')
    dimension_goal_previos_step_2 = @analytics::Dimension.new(name: 'ga:goalPreviousStep2')
    dimension_goal_previos_step_3 = @analytics::Dimension.new(name: 'ga:goalPreviousStep3')
    dimension_segment = @analytics::Dimension.new(name: 'ga:segment')
    dimension_grouping = @analytics::Dimension.new(name: 'ga:channelGrouping')
    metric_session = @analytics::Metric.new(expression: 'ga:sessions', alias: 'sessions')
    metric_completion_all = @analytics::Metric.new(expression: 'ga:goalCompletionsAll', alias: 'goalCompletionsAll')
    request = @analytics::GetReportsRequest.new(
      report_requests: [@analytics::ReportRequest.new(
        view_id: view_id.to_s,
        page_size: 10000,
        dimensions: [dimension_goal_completion, dimension_goal_previos_step_1, dimension_goal_previos_step_2, dimension_goal_previos_step_3, dimension_segment],
        metrics: [metric_session, metric_completion_all],
        date_ranges: [date_range],
        segments: segments,
        orderBys: [{fieldName: 'ga:goalCompletionLocation'}]
      )],
    )
    @reporting_service.batch_get_reports(request)
  end

  def get_goal_conversion view_id, date_range, segments
    analytics_reporting_service
    segments = segments.map{ |item| { segment_id: item } }
    date_range = date_range.delete(' ').split('-')
    date_range = @analytics::DateRange.new(start_date: date_range[0].gsub('/', '-'), end_date: date_range[1].gsub('/', '-'))
    dimension_date = @analytics::Dimension.new(name: 'ga:date')
    dimension_segment = @analytics::Dimension.new(name: 'ga:segment')
    metric_conversion_rate = @analytics::Metric.new(expression: 'ga:goalConversionRateAll', alias: 'goalConversionRateAll')

    request = @analytics::GetReportsRequest.new(
      report_requests: [@analytics::ReportRequest.new(
        view_id: view_id.to_s,
        page_size: 10000,
        dimensions: [dimension_date, dimension_segment],
        metrics: [metric_conversion_rate],
        date_ranges: [date_range],
        segments: segments,
        orderBys: [{fieldName: 'ga:date'}]
      )],
    )
    @reporting_service.batch_get_reports(request)
  end

  def get_channel_data view_id, date_range, segments
    analytics_reporting_service
    segments = segments.map{ |item| { segment_id: item } }
    date_range = date_range.delete(' ').split('-')
    date_range = @analytics::DateRange.new(start_date: date_range[0].gsub('/', '-'), end_date: date_range[1].gsub('/', '-'))
    dimension_grouping = @analytics::Dimension.new(name: 'ga:channelGrouping')
    dimension_segment = @analytics::Dimension.new(name: 'ga:segment')

    metric_user = @analytics::Metric.new(expression: 'ga:users', alias: 'users')
    metric_new_user = @analytics::Metric.new(expression: 'ga:newUsers', alias: 'newUsers')
    metric_session = @analytics::Metric.new(expression: 'ga:sessions', alias: 'sessions')
    metric_bounce_rate = @analytics::Metric.new(expression: 'ga:bounceRate', alias: 'bounceRate')
    metric_page_view_per_session = @analytics::Metric.new(expression: 'ga:pageviewsPerSession', alias: 'pageviewsPerSession')

    metric_avg_session_duration = @analytics::Metric.new(expression: 'ga:avgSessionDuration', alias: 'avgSessionDuration')
    metric_goal_conversion_rate = @analytics::Metric.new(expression: 'ga:goalConversionRateAll', alias: 'goalConversionRateAll')
    metric_goal_completion_all = @analytics::Metric.new(expression: 'ga:goalCompletionsAll', alias: 'goalCompletionsAll')
    metric_goal_value_all = @analytics::Metric.new(expression: 'ga:goalValueAll', alias: 'goalValueAll')
    request = @analytics::GetReportsRequest.new(
      report_requests: [@analytics::ReportRequest.new(
        view_id: view_id.to_s,
        page_size: 10000,
        dimensions: [dimension_grouping, dimension_segment],
        metrics: [metric_user, metric_new_user, metric_session, metric_bounce_rate, metric_page_view_per_session, metric_avg_session_duration,
                    metric_goal_conversion_rate, metric_goal_completion_all, metric_goal_value_all],
        segments: segments,
        date_ranges: [date_range]
      )],
    )
    @reporting_service.batch_get_reports(request)
  end

  def get_list_account
    @service = analytic_service
    account_summaries = {}
    @service.list_account_summaries do |result, err|
      account_summaries[:result] = result
      account_summaries[:error] = err if err.present?
    end
    account_summaries
  end

  def get_list_segment
    @service = analytic_service
    list_segments = @service.list_segments
  end

  def get_list_goals
    @service = analytic_service
    account_summaries = @service.list_goals('~all', '~all', '~all')
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

  def analytic_service
    return @service if @service && !@authorization.expired?

    if @service
      @authorization.refresh!
      @access_token = @authorization.access_token
    else
      @service = Google::Apis::AnalyticsV3::AnalyticsService.new
      @access_token = google_access_token
    end

    client = Signet::OAuth2::Client.new(access_token: @access_token)
    @service.authorization = client
    @service
  end

  def analytics_reporting_service
    return @reporting_service if @reporting_service && !@authorization.expired?

    if @reporting_service
      @authorization.refresh!
      @access_token = @authorization.access_token
    else
      @analytics = Google::Apis::AnalyticsreportingV4
      @reporting_service = @analytics::AnalyticsReportingService.new
      @access_token = google_access_token
    end

    client = Signet::OAuth2::Client.new(access_token: @access_token)
    @reporting_service.authorization = client
    @analytics
  end
end
