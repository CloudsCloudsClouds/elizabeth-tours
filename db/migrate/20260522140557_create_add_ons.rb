class CreateAddOns < ActiveRecord::Migration[8.1]
  def change
    create_table :add_ons do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.string :status
      t.references :tour, null: false, foreign_key: true

      t.timestamps
    end
  end
end
