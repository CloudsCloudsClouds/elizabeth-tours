class AddTranslationsToToursAndAddOns < ActiveRecord::Migration[8.1]
  def change
    add_column :tours, :name_translations, :jsonb, null: false, default: {}
    add_column :tours, :description_translations, :jsonb, null: false, default: {}
    add_column :add_ons, :name_translations, :jsonb, null: false, default: {}
  end
end
