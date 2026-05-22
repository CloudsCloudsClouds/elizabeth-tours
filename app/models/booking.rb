class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  has_many :booking_add_ons, dependent: :destroy
  has_many :add_ons, through: :booking_add_ons

  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled" }
  validates :tour, presence: true
end
