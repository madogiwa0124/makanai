# frozen_string_literal: true

require 'makanai/dbms/mysql'
require 'makanai/settings'

RSpec.describe Makanai::Dbms::Mysql do
  let(:config) do
    {
      host: '0.0.0.0',
      username: 'root',
      password: nil,
      database: 'makanai',
      port: 3306
    }
  end

  let(:root) { Makanai::Settings.app_root_path }

  describe '.initialize' do
    let(:object) { Makanai::Dbms::Mysql.new(config) }

    it 'return Makanai::Dbms::Mysql Object.' do
      expect(object.class).to eq Makanai::Dbms::Mysql
    end

    it 'db is Mysql2::Client object.' do
      expect(object.db.class).to eq Mysql2::Client
    end
  end

  describe '#execute_sql' do
    let(:db_path) { "#{root}/spec/db/makanai.db" }
    let(:create_table_sql) { File.read("#{root}/spec/migration/create_numbers.sql") }
    let(:drop_table_sql) { File.read("#{root}/spec/migration/drop_numbers.sql") }
    let(:show_tables_sql) { 'show tables;' }

    def create_and_drop_numbers(&block)
      Makanai::Dbms::Mysql.new(config).execute_sql(create_table_sql)
      result = block.call
      Makanai::Dbms::Mysql.new(config).execute_sql(drop_table_sql)
      result
    end

    before { allow(STDOUT).to receive(:puts) }

    it 'created numbar table.' do
      db = Makanai::Dbms::Mysql.new(config)
      result = create_and_drop_numbers { db.execute_sql(show_tables_sql) }
      expect(result.map { |n| n['Tables_in_makanai'] }).to include 'numbers'
    end
  end
end
