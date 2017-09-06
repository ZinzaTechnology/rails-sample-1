class TrackingLogsController < ApplicationController
  def index
    @tracking_logs = TrackingLog.next_page(params[:last_id])
  end
end
