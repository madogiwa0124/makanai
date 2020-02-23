# frozen_string_literal: true

require 'makanai/database'
require 'makanai/settings'

RSpec.describe Makanai::Database do
  let(:root) { Makanai::Settings.app_root_path }

  describe '.initialize' do
    let(:object) { Makanai::Database.new(path: "#{root}/spec/db/makanai.db") }

    it 'return Makanai::Database Object.' do
      expect(object.class).to eq Makanai::Database
    end

    context 'client is not cofigured.' do
      it 'default client is Makanai::Dbms::Sqlite.' do
        expect(object.client.class).to eq Makanai::Dbms::Sqlite
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
      end
      db = Makanai::Database.new(client: client, path: 'path')
      expect(db.execute_sql('sql')).to eq 'sql'
    end
  end
end
