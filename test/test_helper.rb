require "minitest/autorun"
require "minitest/pride"

require "active_record"
require "pry"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/test.sqlite3"
)

require "./todo"
require "./db/migrations/create_to_dos_table_migration"

begin
  CreateToDosTableMigration.migrate(:down)
rescue ActiveRecord::StatementInvalid
end
CreateToDosTableMigration.migrate(:up)

require "./list"
require "./db/migrations/create_lists_table_migration"

begin
  CreateListsTableMigration.migrate(:down)
rescue ActiveRecord::StatementInvalid
end
CreateListsTableMigration.migrate(:up)
