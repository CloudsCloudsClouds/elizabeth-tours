class AddActiveToAddOns < ActiveRecord::Migration[8.1]
  def change
    add_column :add_ons, :active, :boolean
  end
end
