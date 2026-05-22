class AddOn < ApplicationRecord
  belongs_to :tour
  has_many :booking_add_ons, dependent: :destroy
  has_many :bookings, through: :booking_add_ons
end
