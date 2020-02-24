# frozen_string_literal: true

require 'mysql2'

module Makanai
  module Dbms
    class Mysql
      def initialize(config)
        @db = Mysql2::Client.new(config || default_config)
      end

      attr_reader :db

      def execute_sql(sql)
        db.query(sql).to_a.tap { close_db }
      end

      private

      def default_config
        {
          host: '0.0.0.0',
          username: 'root',
          password: 'password',
          database: 'makanai',
          port: 3306
        }
      end

      def close_db
        db.close
      end
    end
  end
end
