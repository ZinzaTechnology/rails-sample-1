module UserDecorator
  def list_working_time
    times_to_check.split(',')
  end

  def csv_row_data
    list_working_time.each_slice(2).reduce([full_name]) do |data, (check_in, check_out)|
      check_in = I18n.l(check_in.to_datetime.localtime, format: :hour_minute) if check_in.present?
      check_out = I18n.l(check_out.to_datetime.localtime, format: :hour_minute) if check_out.present?
      data << "#{check_in}~#{check_out}"
    end
  end
end
