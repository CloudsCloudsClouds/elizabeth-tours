class Tour < ApplicationRecord
  has_many :add_ons, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images

  validates :base_price, numericality: { greater_than_or_equal_to: 0 }
end
