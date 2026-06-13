class CreateBackups < ActiveRecord::Migration[8.1]
  def change
    create_table :backups do |t|
      t.string :name
      t.string :file_path
      t.bigint :file_size
      t.string :database

      t.timestamps
    end
    add_index :backups, :name, unique: true
  end
end
