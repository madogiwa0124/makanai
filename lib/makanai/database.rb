# frozen_string_literal: true

require_relative './dbms/sqlite.rb'
require_relative './settings.rb'

module Makanai
  class Database
    class UnsupportedException < StandardError; end

    def initialize(client: Settings.databse_client, config: Settings.databse_config)
      case client.name
      when Makanai::Dbms::Sqlite.name, Makanai::Dbms::Postgres.name
        @client = client.new(config)
      else
        raise UnsupportedException
      end
    end

    attr_reader :client

    def execute_sql(sql)
      puts "SQL: #{sql.gsub("\n", ' ')}"
      client.execute_sql(sql)
    end
  end
end
