class Group < ApplicationRecord
  include CommonScope

  has_many :user_groups, dependent: :destroy
  has_many :group_permissions, dependent: :destroy
  has_many :permissions, through: :group_permissions
  has_many :users, through: :user_groups

  validates :name, presence: true, uniqueness: true
end
