class AddFieldsToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :tour_date, :datetime
    add_column :bookings, :num_guests, :integer
  end
end
