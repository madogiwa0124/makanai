# frozen_string_literal: true

require 'sqlite3'
require_relative '../config/settings.rb'

module Makanai
  class Model
    class NotFound < StandardError; end

    def initialize(attributes)
      @attributes = attributes
      difine_attribute_methods
    end

    attr_reader :attributes

    def self.execute_sql(sql)
      connect_db
      # TODO: Escape SQL
      @db.execute(sql).tap { close_db }
    end

    def self.all
      results = execute_sql("SELECT * FROM #{self::TABLE_NAME};")
      results.map { |result| new(result) }
    end

    def self.find(key)
      results = execute_sql(
        <<~SQL
          SELECT *
          FROM #{self::TABLE_NAME}
          WHERE #{self::PRYMARY_KEY} = '#{key}'
          LIMIT 1
        SQL
      )
      raise Makanai::Model::NotFound if results.empty?
      new(results.pop)
    end

    def self.connect_db
      @db = SQLite3::Database.new Makanai::Settings::DATABASE_NAME
      @db.tap { |db| db.results_as_hash = true }
    end

    def self.close_db
      @db.close
    end

    private

    def difine_attribute_methods
      attributes.each do |key, val|
        instance_variable_set("@#{key}".to_sym, val)
        self.class.class_eval { attr_accessor key.to_sym }
      end
    end
  end
end
