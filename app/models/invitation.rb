class Invitation < ApplicationRecord
  include InvitationDecorator
  include CommonScope

  attr_accessor :used_alias, :alias_name, :current_user, :user_list

  before_save :update_user_list

  has_many :user_invitations
  has_many :users, through: :user_invitations
  has_many :interviews, through: :user_invitations
  has_many :pending_user_invitations, ->{pending}, class_name: UserInvitation.name
  has_many :approved_user_invitations, ->{approved}, class_name: UserInvitation.name
  has_many :declined_user_invitations, ->{declined}, class_name: UserInvitation.name
  has_many :evaluated_user_invitations, ->{evaluated}, class_name: UserInvitation.name
  has_many :pending_users, through: :pending_user_invitations, source: :user
  has_many :approved_users, through: :approved_user_invitations, source: :user
  has_many :evaluated_users, through: :evaluated_user_invitations, source: :user
  has_many :declined_users, through: :declined_user_invitations, source: :user

  belongs_to :candidate

  enum position: {intern: 0, fresher: 1, junior: 2, senior: 3}
  enum division: {D1: 0, D2: 1}
  enum status: {unfinished: 0, canceled: 1, finished: 2}

  delegate :name, to: :candidate, prefix: true, allow_nil: true

  validates :interview_date, future_date: true, if: :interview_date_changed?
  validates :room, :status, :interview_date, presence: true
  validates :alias_name, presence: true, if: ->{used_alias}
  validates :user_list, interview_approved: true

  scope :expired, ->{where('interview_date < ?', Time.zone.now)}
  scope :not_expire, ->{where('interview_date >= ?', Time.zone.now)}

  INFORMATION_ATTRIBUTE = %w(room interview_date position division).freeze

  def change_information
    interview_date_changed? || canceled?
  end

  private

  def update_user_list
    return unless user_list
    self.user_ids = user_list
  end
end
