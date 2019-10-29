# frozen_string_literal: true

require_relative './settings.rb'
require_relative './database.rb'

module Makanai
  module Migration
    def execute_sql(sql_path:, db: Makanai::Database.new)
      sql = File.read(sql_path)
      puts "execute: #{sql_path}"
      db.execute_sql(sql)
    end

    def migration_root_path
      "#{Settings::APP_ROOT_PATH}#{Settings::MIGRATION_ROOT_PATH}"
    end
  end
end
