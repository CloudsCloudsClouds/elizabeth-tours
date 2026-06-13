class ChangeBasePriceToDecimalInTours < ActiveRecord::Migration[8.1]
  def change
    def up
      change_column :tours, :base_price, :decimal, precision: 10, scale: 2
    end

    def down
      change_column :tours, :base_price, :float
    end
  end
end
