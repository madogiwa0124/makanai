# frozen_string_literal: true

require 'rake'
require 'sqlite3'
require_relative './migration.rb'
require_relative './generator.rb'

namespace :makanai do
  namespace :initialize do
    desc 'create directies and files for makanai initialization.'
    task :app do
      generator = Makanai::Generator.new
      puts 'INFO: start ganerate app'
      puts generator.create_app_directories
      puts generator.create_app_rb
      puts generator.create_rakefile
      puts generator.create_cofig_ru
      puts 'INFO: finished ganerate app'
    end
  end

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
        execute_sql(sql_path: File.join(migration_root_path, target))
      end
      puts "INFO: finished migration #{ENV['target']}"
    end
  end
end
