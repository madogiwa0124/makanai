# frozen_string_literal: true

require 'makanai/dbms/sqlite'
require 'makanai/settings'

RSpec.describe Makanai::Dbms::Sqlite do
  let(:root) { Makanai::Settings.app_root_path }

  describe '.initialize' do
    let(:config) { { path: "#{root}/spec/db/makanai.db" } }
    let(:object) { Makanai::Dbms::Sqlite.new(config) }

    it 'return Makanai::Dbms::Sqlite Object.' do
      expect(object.class).to eq Makanai::Dbms::Sqlite
    end

    it 'db is SQLite3::Database object.' do
      expect(object.db.class).to eq SQLite3::Database
    end

    it 'db.results_as_hash is true.' do
      expect(object.db.results_as_hash).to eq true
    end
  end

  describe '#execute_sql' do
    let(:config) { { path: "#{root}/spec/db/makanai.db" } }
    let(:create_table_sql) { File.read("#{root}/spec/migration/create_numbers.sql") }
    let(:drop_table_sql) { File.read("#{root}/spec/migration/drop_numbers.sql") }
    let(:show_tables_sql) { "select name from sqlite_master where type='table';" }

    def create_and_drop_numbers(&block)
      Makanai::Dbms::Sqlite.new(config).execute_sql(create_table_sql)
      result = block.call
      Makanai::Dbms::Sqlite.new(config).execute_sql(drop_table_sql)
      result
    end

    before { allow(STDOUT).to receive(:puts) }

    it 'created numbar table.' do
      db = Makanai::Dbms::Sqlite.new(config)
      result = create_and_drop_numbers { db.execute_sql(show_tables_sql) }
      expect(result.map { |table| table['name'] }).to include 'numbers'
    end
  end
end
