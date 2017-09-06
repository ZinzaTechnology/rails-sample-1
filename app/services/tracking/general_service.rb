class Tracking::GeneralService
  attr_reader :resource, :current_user, :act_type

  def initialize resource, current_user, act_type
    @resource = resource
    @current_user = current_user
    @act_type = act_type
  end

  def perform
    result = service_running
    create_tracking_log if result[:success]

    {
      success: result[:success],
      message: result[:message],
      resource: resource
    }
  end

  private

  def service_running
    raise NotImplementedError
  end

  def create_tracking_log
    tracking_log = TrackingLog.new resource: resource, owner: current_user, act_type: act_type
    tracking_log.save validate: false
  end
end
