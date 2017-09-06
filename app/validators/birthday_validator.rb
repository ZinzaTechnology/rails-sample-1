class BirthdayValidator < ActiveModel::EachValidator
  def validate_each record, attr_name, _value
    return unless record.birth_y.present? && record.birth_m.present? && record.birth_d.present?
    record.birthday = Date.parse "#{record.birth_y}-#{record.birth_m}-#{record.birth_d}"
  rescue ArgumentError
    record.errors.add attr_name, :invalid_birthday
  end
end
