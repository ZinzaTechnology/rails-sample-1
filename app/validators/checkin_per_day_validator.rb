class CheckinPerDayValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return unless value
    record.errors.add attribute if WorkingTime.on_today.find_by(user_id: record.user_id)
  end
end
