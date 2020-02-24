# frozen_string_literal: true

require 'sqlite3'

module Makanai
  module Dbms
    class Sqlite
      def initialize(config)
        @db = SQLite3::Database.new(config[:path])
        db.tap { |db| db.results_as_hash = true }
      end

      attr_reader :db

      def execute_sql(sql)
        db.execute(sql).tap { close_db }
      end

      private

      def close_db
        db.close
      end
    end
  end
end
