# frozen_string_literal: true

require_relative './dbms/sqlite'
require_relative './settings'

module Makanai
  class Database
    class UnsupportedException < StandardError; end

    def initialize(client: Settings.databse_client, config: Settings.databse_config)
      client_class = client_class(client)
      @client = client_class.new(config)
    end

    attr_reader :client

    def execute_sql(sql)
      puts "SQL: #{sql.gsub("\n", ' ')}"
      client.execute_sql(sql)
    end

    private

    def client_class(client)
      require_relative File.join('dbms', client.to_s)
      Object.const_get("Makanai::Dbms::#{client.capitalize}")
    rescue LoadError
      raise UnsupportedException
    end
  end
end
