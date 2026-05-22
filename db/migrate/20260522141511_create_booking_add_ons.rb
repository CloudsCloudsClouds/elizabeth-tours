class CreateBookingAddOns < ActiveRecord::Migration[8.1]
  def change
    create_table :booking_add_ons, primary_key: [ :booking_id, :add_on_id ], force: :cascade do |t|
      t.integer :add_on_id, null: false
      t.integer :booking_id, null: false
      t.timestamps
    end

    add_index :booking_add_ons, :add_on_id
    add_index :booking_add_ons, :booking_id
    add_foreign_key :booking_add_ons, :add_ons
    add_foreign_key :booking_add_ons, :bookings
  end
end
