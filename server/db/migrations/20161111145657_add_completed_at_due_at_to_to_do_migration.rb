class AddCompletedAtDueAtToToDoMigration < ActiveRecord::Migration[5.0]
  def change
    add_column :to_dos, :completed_at, :datetime
    add_column :to_dos, :due_at, :datetime
  end
end
