require 'active_support/concern'

module CommonScope
  extend ActiveSupport::Concern

  included do
    scope :id_asc, ->{order(id: :asc)}
    scope :id_desc, ->{order(id: :desc)}
  end
end
