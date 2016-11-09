
require "pry"
require "active_record"

require_relative "db/connection"
require_relative "db/migrations/create_to_dos_table_migration"
require_relative "db/migrations/create_lists_table_migration"
require_relative "to_do"

Pry.start
