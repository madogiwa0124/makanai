# frozen_string_literal: true

require_relative './database.rb'

module Makanai
  class Model
    class NotFound < StandardError; end

    def initialize(attributes)
      @origin_attributes = attributes
      difine_attribute_methods
    end

    attr_reader :origin_attributes

    def self.execute_sql(sql, db = Makanai::Database.new)
      db.execute_sql(sql)
    end

    def self.all(db = Makanai::Database.new)
      results = execute_sql("SELECT * FROM #{self::TABLE_NAME};", db)
      results.map { |result| new(result) }
    end

    def self.find(key, db = Makanai::Database.new)
      sql = <<~SQL
        SELECT *
        FROM #{self::TABLE_NAME}
        WHERE #{self::PRYMARY_KEY} = #{buid_sql_text(key)}
        LIMIT 1;
      SQL
      results = execute_sql(sql, db)
      raise Makanai::Model::NotFound if results.empty?
      new(results.pop)
    end

    def self.first(db = Makanai::Database.new)
      sql = <<~SQL
        SELECT *
        FROM #{self::TABLE_NAME}
        ORDER BY #{self::PRYMARY_KEY} ASC
        LIMIT 1;
      SQL
      new(execute_sql(sql, db).pop)
    end

    def self.last(db = Makanai::Database.new)
      sql = <<~SQL
        SELECT *
        FROM #{self::TABLE_NAME}
        ORDER BY #{self::PRYMARY_KEY} DESC
        LIMIT 1;
      SQL
      new(execute_sql(sql, db).pop)
    end

    def self.buid_sql_text(value)
      case value
      when String then "'#{value.gsub(/'/, "''")}'"
      when Numeric, Integer then value
      else value
      end
    end

    def assign_attributes(attributes)
      attributes.each { |key, val| send("#{key}=", val) }
      self
    end

    def attributes
      origin_attributes.map { |key, _val| [key, send(key)] }.to_h
    end

    def create(db = Makanai::Database.new)
      sql = <<~SQL
        INSERT
        INTO #{self.class::TABLE_NAME}(#{clumns.join(',')})
        VALUES (#{insert_values.join(',')});
      SQL
      self.class.execute_sql(sql, db)
      @origin_attributes = self.class.last.attributes
      difine_attribute_methods
      self
    end

    def update(db = Makanai::Database.new)
      sql = <<~SQL
        UPDATE #{self.class::TABLE_NAME}
        SET #{update_values.join(',')}
        WHERE #{self.class::PRYMARY_KEY} = #{self.class.buid_sql_text(send(self.class::PRYMARY_KEY))};
      SQL
      self.class.execute_sql(sql, db)
      @origin_attributes = attributes
      difine_attribute_methods
      self
    end

    def delete(db = Makanai::Database.new)
      sql = <<~SQL
        DELETE FROM #{self.class::TABLE_NAME}
        WHERE #{self.class::PRYMARY_KEY} = #{self.class.buid_sql_text(send(self.class::PRYMARY_KEY))};
      SQL
      self.class.execute_sql(sql, db)
      nil
    end

    private

    def clumns
      attributes.keys
    end

    def insert_values
      attributes.values.map { |attribute| self.class.buid_sql_text(attribute).to_s }
    end

    def update_values
      attributes.map { |key, val| "#{key}=#{self.class.buid_sql_text(val)}" }
    end

    def difine_attribute_methods
      origin_attributes.each do |key, val|
        instance_variable_set("@#{key}".to_sym, val)
        self.class.class_eval { attr_accessor key.to_sym }
      end
    end
  end
end
