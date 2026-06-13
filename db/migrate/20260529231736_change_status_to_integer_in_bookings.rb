class ChangeStatusToIntegerInBookings < ActiveRecord::Migration[8.1]
  def change
    def up
      change_column :bookings, :status, :integer, default: 0, null: false
    end

    def down
      change_column :bookings, :status, :string
    end
  end
end
