class NotAllowPastDayValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return unless value
    record.errors.add attribute, :not_allow_past_day if value < Time.current
  end
end
