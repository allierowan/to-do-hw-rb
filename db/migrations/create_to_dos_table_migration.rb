class CreateToDosTableMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :to_dos do |t|
      t.text :description
      t.boolean :is_complete
      t.timestamps
    end
  end
end
