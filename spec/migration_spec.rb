# frozen_string_literal: true

require 'makanai/migration'
require 'makanai/settings'

RSpec.describe Makanai::Migration do
  let(:root) { Makanai::Settings.app_root_path }
  let(:migratable_object) { Class.new { include Makanai::Migration }.new }

  describe '#migration_root_path' do
    it 'return migration root path.' do
      migration_path = Makanai::Settings.migration_root_path
      expect(migratable_object.migration_root_path).to eq "#{root}#{migration_path}"
    end
  end

  describe '#execute_sql' do
    let(:path) { "#{root}/spec/db/makanai.db" }
    let(:create_table_sql_path) { "#{root}/spec/migration/create_numbers.sql" }
    let(:show_tables_sql) { "select name from sqlite_master where type='table';" }

    before do
      allow($stdout).to receive(:puts)
      db = Makanai::Database.new(config: { path: path })
      migratable_object.execute_sql(sql_path: create_table_sql_path, db: db)
    end

    after do
      drop_table_sql = File.read("#{root}/spec/migration/drop_numbers.sql")
      Makanai::Database.new(config: { path: path }).execute_sql(drop_table_sql)
    end

    it 'created numbar table.' do
      result = Makanai::Database.new(config: { path: path }).execute_sql(show_tables_sql)
      expect(result.map { |table| table['name'] }).to include 'numbers'
    end
  end
end
