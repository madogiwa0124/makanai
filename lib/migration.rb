# frozen_string_literal: true

module Makanai
  module Migration
    def execute_sql(db:, sql_path:)
      sql = File.read(sql_path)
      puts "execute: #{sql_path}"
      puts sql
      db.execute sql
    end
  end
end
