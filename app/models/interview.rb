class Interview < ApplicationRecord
  include InterviewDecorator
  include CommonScope

  belongs_to :user_invitation
  has_one :user, through: :user_invitation
  has_one :invitation, through: :user_invitation
  has_one :candidate, through: :invitation

  enum status: {failed: 0, considered: 1, passed: 2}

  delegate :interview_date, to: :invitation, prefix: true, allow_nil: true
  delegate :email, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :candidate, prefix: true, allow_nil: true

  validates :status, :evaluate, presence: true
  validates :status, :evaluate, not_allow_after_three_day: true, on: :owner
  validates :status, :evaluate, not_allow_after_one_month: true, on: :manager

  def can_update_offer?
    !failed? && offer.nil?
  end
end
