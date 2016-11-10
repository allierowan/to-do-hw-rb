ENV["RACK_ENV"] = "test"

require "bundler/setup"

begin
  require "pry"
rescue LoadError
end

require "minitest/autorun"
require "minitest/pride"
require "minitest/focus"
require "rack/test"

require_relative "../lib/app"
