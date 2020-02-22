# frozen_string_literal: true

require 'sqlite3'
require_relative './settings.rb'

module Makanai
  class Database
    def initialize(path: Settings.database_full_path)
      @handler = SQLite3::Database
      @db = handler.new path
      db.tap { |db| db.results_as_hash = true }
    end

    attr_reader :handler, :db

    def execute_sql(sql)
      puts "SQL: #{sql.gsub("\n", ' ')}"
      db.execute(sql).tap { close_db }
    end

    private

    def close_db
      db.close
    end
  end
end
