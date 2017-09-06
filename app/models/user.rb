class User < ApplicationRecord
  include CommonScope
  include UserDecorator

  has_one :profile, dependent: :destroy
  has_one :working_time_today, ->{on_today}, class_name: WorkingTime.name
  has_one :nickname

  has_many :groups, through: :user_groups
  has_many :requests, dependent: :destroy
  has_many :members, class_name: User.name, foreign_key: :superior_id
  belongs_to :superior, class_name: User.name, optional: true

  accepts_nested_attributes_for :profile, update_only: true

  scope :by_ids, ->(ids){where id: ids}
  scope :except_ids, ->(ids){where.not(id: ids)}

  validates_associated :profile

  delegate :full_name, :given_name, :family_name, :position, :address, :birthday, :gender, :position_name, :gender_type,
    :male?, :female?, :birth_day, :intern?, :tracking?, to: :profile, allow_nil: true
  delegate :email, to: :superior, prefix: :superior, allow_nil: true
  delegate :token, to: :nickname, prefix: true, allow_nil: true

  def permissions
    groups.includes(:permissions).flat_map(&:permissions).uniq.pluck(:name)
  end

  def check_in_on_today?
    working_time_today&.check_in
  end

  def check_out_on_today?
    working_time_today&.check_out
  end
end
