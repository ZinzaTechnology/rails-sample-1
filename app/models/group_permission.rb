class GroupPermission < ApplicationRecord
  belongs_to :permission
  belongs_to :group
end
