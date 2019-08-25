# frozen_string_literal: true

require 'rake'
require 'sqlite3'
require_relative './lib/migration.rb'
require_relative './config/settings.rb'

namespace :makanai do
  namespace :db do
    desc 'execute migration'
    task :migration do
      include Makanai::Migration

      puts "INFO: start migration #{ENV['target']}"
      target = ENV['target']
      db = SQLite3::Database.new db_path
      if target == 'all'
        sql_paths = Dir.glob("#{migration_root_path}*")
        sql_paths.each { |sql_path| execute_sql(db: db, sql_path: sql_path) }
      else
        sql_path = "#{migration_root_path}#{target}"
        execute_sql(db: db, sql_path: sql_path)
      end
      db.close
      puts "INFO: finished migration #{ENV['target']}"
    end
  end
end
