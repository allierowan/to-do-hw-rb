require "pry"
require "active_record"
require_relative "../to_do"
require_relative "../list"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/dev.sqlite3"
)
