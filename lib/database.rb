# frozen_string_literal: true

require 'sqlite3'
require_relative '../config/settings.rb'

module Makanai
  class Database
    DATABASE_PATH = "#{Settings::APP_ROOT_PATH}#{Settings::DATABASE_PATH}"

    def initialize
      @handler = SQLite3::Database
      @db = handler.new DATABASE_PATH
      db.tap { |db| db.results_as_hash = true }
    end

    attr_reader :handler, :db

    def execute_sql(sql)
      puts "SQL: #{sql.gsub("\n", ' ')}"
      db.execute(sql).tap { close_db }
    end

    def close_db
      db.close
    end
  end
end
