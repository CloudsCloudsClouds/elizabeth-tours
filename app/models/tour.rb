class Tour < ApplicationRecord
  has_many :add_ons, dependent: :destroy
  has_many :bookings, dependent: :destroy
end
