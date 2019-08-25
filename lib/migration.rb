# frozen_string_literal: true

module Makanai
  module Migration
    def db_path
      "#{Makanai::Settings::APP_ROOT_PATH}#{Makanai::Settings::DATABASE_PATH}"
    end

    def execute_sql(db:, sql_path:)
      sql = File.read(sql_path)
      puts "execute: #{sql_path}"
      puts sql
      db.execute sql
    end
  end
end
