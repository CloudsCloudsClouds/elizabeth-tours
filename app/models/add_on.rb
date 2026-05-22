class AddOn < ApplicationRecord
  belongs_to :tour
  has_many :booking_add_ons, dependent: :destroy
  has_many :bookings, through: :booking_add_ons


  enum :status, { unavailable: "unavailable", available: "available" }, prefix: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
