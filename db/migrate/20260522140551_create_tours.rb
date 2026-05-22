class CreateTours < ActiveRecord::Migration[8.1]
  def change
    create_table :tours do |t|
      t.string :name
      t.text :description
      t.float :base_price

      t.timestamps
    end
  end
end
