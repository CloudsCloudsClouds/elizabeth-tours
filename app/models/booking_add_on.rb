class BookingAddOn < ApplicationRecord
  self.primary_key = [ :booking_id, :add_on_id ]

  belongs_to :booking
  belongs_to :add_on
end
