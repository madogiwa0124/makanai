# frozen_string_literal: true

require 'pg'

module Makanai
  module Dbms
    class Postgres
      def initialize(config)
        @db = PG.connect(config || default_config)
        db.type_map_for_results = PG::BasicTypeMapForResults.new(db)
      end

      attr_reader :db

      def execute_sql(sql)
        db.exec(sql).each.to_a.tap { close_db }
      end

      private

      def default_config
        {
          host: 'localhost',
          password: nil,
          dbname: 'makanai',
          port: 5432
        }
      end

      def close_db
        db.finish
      end
    end
  end
end
