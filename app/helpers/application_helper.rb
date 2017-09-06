# frozen_string_literal: false

module ApplicationHelper
  def show_errors(object, field_name)
    return unless object.errors.any?

    str = "<ul class='tm-validation-errors'>"
    object.errors.full_messages_for(field_name).uniq.each do |message|
      str += "<li class='tm-validation-error-message'>#{message}</li>"
    end
    str += '</ul>'
    str.html_safe
  end

  def paginate(objects, options = {})
    options.reverse_merge!(theme: 'twitter-bootstrap-3', remote: true)

    super(objects, options)
  end

  def format_date(date, type = '%Y-%m-%d %H:%M')
    date ? date.strftime(type) : ''
  end
end
