module DashboardUtil
  NUM_AGO = 7

  def get_date_labels
    @array_labels = (0..NUM_AGO).to_a.reverse
    case @graph_by
    when 'week'
      cal_labels_by_week
    when 'day'
      cal_labels_by_day
    when 'month'
      cal_labels_by_month
    end
  end

  private

  def cal_labels_by_week
    @array_labels.reduce(Array.new) { |a, e| a << e.weeks.ago.beginning_of_week.strftime("%m/%d〜") }
  end

  def cal_labels_by_day
    @array_labels.reduce(Array.new) { |a, e| a << e.days.ago.strftime("%m/%d〜") }
  end

  def cal_labels_by_month
    @array_labels.reduce(Array.new) { |a, e| a << e.months.ago.beginning_of_month.strftime("%m/%d〜") }
  end

  def build_times_list
    times = @messages.pluck(:send_date).sort
    list = Hash.new
    index = 0
    start_time = times.first

    times.each do |time|
      if time <= start_time + NUMBER_OF_MINUTES_AFTER_MESSAGE_SENT.minutes
        time == start_time ? list[index] = [time, time + NUMBER_OF_MINUTES_AFTER_MESSAGE_SENT.minutes] : list[index][1] = time + NUMBER_OF_MINUTES_AFTER_MESSAGE_SENT.minutes
      else
        index += 1
        list[index] = [time, time + NUMBER_OF_MINUTES_AFTER_MESSAGE_SENT.minutes]
      end
      start_time = time
    end

    list.values
  end

  def raw_times_query times
    times.reduce(String.new) do |query, time|
      query << " OR create_time BETWEEN '#{time[0]}' AND '#{time[1]}'"
    end[4..-1]
  end

  def standardized_times times
    times = times.select {|time| (NUM_AGO.send(@graph_by).ago.send("beginning_of_#{@graph_by}")..Time.zone.now).include?(time[0]..time[1])}
    {times: times, type: @graph_by.to_sym}
  end

  def all_review_from_message(reviews)
    times = build_times_list
    times.present? ? reviews.where(raw_times_query(times)) : reviews.none
  end
end
