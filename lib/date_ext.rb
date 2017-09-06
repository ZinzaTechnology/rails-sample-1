require 'holidays/core_extensions/date'

class Date
  include Holidays::CoreExtensions::Date

  def on_holiday?
    saturday? || sunday? || holiday?(:vi)
  end

  def company_lunch?
    beginning_of_hour == middle_of_day
  end
end
