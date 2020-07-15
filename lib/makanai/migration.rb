# frozen_string_literal: true

require_relative './settings'
require_relative './database'

module Makanai
  module Migration
    def execute_sql(sql_path:, db: Makanai::Database.new)
      sql = File.read(sql_path)
      puts "execute: #{sql_path}"
      db.execute_sql(sql)
    end

    def migration_root_path
      Settings.migration_full_path
    end
  end
end
