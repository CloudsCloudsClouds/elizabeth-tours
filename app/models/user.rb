class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :tours, through: :bookings

  enum :role, { customer: 0, admin: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
