class CreateToDosTableMigrationMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :to_dos do |t|
      t.text :description
      t.boolean :is_complete, default: :false
      t.integer :list_id
      t.timestamps
    end
  end
end
