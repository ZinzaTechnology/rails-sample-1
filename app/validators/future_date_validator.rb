class FutureDateValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    record.errors.add attribute, :future_date if less_than_now?(value)
  end

  private

  def less_than_now? value
    value.blank? || value < Time.zone.now
  end
end
