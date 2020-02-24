# frozen_string_literal: true

require 'makanai/dbms/postgres'
require 'makanai/settings'

RSpec.describe Makanai::Dbms::Postgres do
  let(:config) do
    { host: '0.0.0.0',
      password: nil,
      dbname: 'makanai',
      port: 5432 }
  end

  let(:root) { Makanai::Settings.app_root_path }

  describe '.initialize' do
    let(:object) { Makanai::Dbms::Postgres.new(config) }

    it 'return Makanai::Dbms::Postgres Object.' do
      expect(object.class).to eq Makanai::Dbms::Postgres
    end

    it 'db is PG::Connection object.' do
      expect(object.db.class).to eq PG::Connection
    end
  end

  describe '#execute_sql' do
    let(:db_path) { "#{root}/spec/db/makanai.db" }
    let(:create_table_sql) { File.read("#{root}/spec/migration/create_numbers.sql") }
    let(:drop_table_sql) { File.read("#{root}/spec/migration/drop_numbers.sql") }
    let(:show_tables_sql) do
      "SELECT * FROM information_schema.tables WHERE table_schema='public'"
    end

    def create_and_drop_numbers(&block)
      Makanai::Dbms::Postgres.new(config).execute_sql(create_table_sql)
      result = block.call
      Makanai::Dbms::Postgres.new(config).execute_sql(drop_table_sql)
      result
    end

    before { allow(STDOUT).to receive(:puts) }

    it 'created numbar table.' do
      db = Makanai::Dbms::Postgres.new(config)
      result = create_and_drop_numbers { db.execute_sql(show_tables_sql) }
      expect(result.map { |n| n['table_name'] }).to include 'numbers'
    end
  end
end
