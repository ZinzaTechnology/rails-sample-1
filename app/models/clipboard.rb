class Clipboard < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :content, presence: true

  before_validation :prepare_data

  scope :viewable, ->{where('valid_until >= ?', Time.zone.now)}
  scope :expired, ->{where('valid_until < ?', Time.zone.now)}

  private

  def prepare_data
    self.code = loop do
      random_token = SecureRandom.hex(12)
      break random_token unless Clipboard.exists? code: random_token
    end
    self.valid_until = Time.zone.now + 1.day
  end
end
