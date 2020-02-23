# frozen_string_literal: true

require_relative './dbms/sqlite.rb'
require_relative './settings.rb'

module Makanai
  class Database
    def initialize(client: Dbms::Sqlite, path: Settings.database_full_path)
      @client = client.new(path)
    end

    attr_reader :client

    def execute_sql(sql)
      puts "SQL: #{sql.gsub("\n", ' ')}"
      client.execute_sql(sql)
    end
  end
end
