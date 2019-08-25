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
      if target == 'all'
        sql_paths = Dir.glob("#{migration_root_path}*")
        sql_paths.each { |sql_path| execute_sql(sql_path: sql_path) }
      else
        execute_sql(sql_path: "#{migration_root_path}#{target}")
      end
      puts "INFO: finished migration #{ENV['target']}"
    end
  end
end
