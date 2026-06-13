class ChangeStatusToIntegerInAddOns < ActiveRecord::Migration[8.1]
  def change
    def up
      change_column :add_ons, :status, :integer, default: 0, null: false
    end

    def down
      change_column :add_ons, :status, :string
    end
  end
end
