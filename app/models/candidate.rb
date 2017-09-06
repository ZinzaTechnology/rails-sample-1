class Candidate < ApplicationRecord
  attr_accessor :allow_coincide, :birth_y, :birth_m, :birth_d

  include CandidateDecorator
  include CommonScope

  has_many :invitations
  has_many :user_invitations, through: :invitations
  has_many :interviews, through: :user_invitations

  enum location: {HaNoi: 0, HoChiMinh: 1, DaNang: 2, Japan: 3}

  delegate :file_url, to: :recent_attachment, allow_nil: true, prefix: true

  validates :name, presence: true
  validates :birthday, birthday: true

  scope :by_ids, ->(ids){where id: ids}
end
