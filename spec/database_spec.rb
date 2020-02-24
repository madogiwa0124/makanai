# frozen_string_literal: true

require 'makanai/database'
require 'makanai/settings'

RSpec.describe Makanai::Database do
  let(:root) { Makanai::Settings.app_root_path }

  describe '.initialize' do
    let(:client) { Makanai::Dbms::Sqlite }
    let(:object) do
      Makanai::Database.new(
        client: client,
        config: { path: "#{root}/spec/db/makanai.db" }
      )
    end

    it 'return Makanai::Database Object.' do
      expect(object.class).to eq Makanai::Database
    end

    context 'client is not cofigured.' do
      it 'default client is Makanai::Dbms::Sqlite.' do
        expect(object.client.class).to eq Makanai::Dbms::Sqlite
      end
    end

    context 'configured not supported client.' do
      class NotSupportClient; end
      let(:client) { NotSupportClient }

      it 'default client is Makanai::Dbms::Sqlite.' do
        expect { object }.to raise_error Makanai::Database::UnsupportedException
      end
    end
  end

  describe '#execute_sql' do
    before { allow(STDOUT).to receive(:puts) }

    it 'created numbar table.' do
      client = Class.new do
        def initialize(path); end

        def execute_sql(sql)
          sql
        end

        def self.name
          Makanai::Dbms::Sqlite.name
        end
      end
      db = Makanai::Database.new(client: client, config: { path: 'path' })
      expect(db.execute_sql('sql')).to eq 'sql'
    end
  end
end
