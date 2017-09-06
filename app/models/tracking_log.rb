class TrackingLog < ApplicationRecord
  include TrackingLogDecorator
  include CommonScope

  belongs_to :resource, polymorphic: true
  belongs_to :owner, class_name: User.name

  enum act_type: %i(add change remove)

  delegate :email, to: :owner, prefix: true, allow_nil: true

  scope :next_page, (lambda do |id|
    if id
      where('id < ?', id)
    else
      self
    end.limit(Settings.number_per_page.logs).id_desc.includes(:owner, :resource).sort_by(&:id)
  end)
end
