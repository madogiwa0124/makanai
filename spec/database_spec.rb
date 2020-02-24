# frozen_string_literal: true

require 'makanai/database'
require 'makanai/settings'

RSpec.describe Makanai::Database do
  let(:root) { Makanai::Settings.app_root_path }

  describe '.initialize' do
    let(:client) { :sqlite }
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
      let(:client) { :not_support }

      it 'raise UnsupportedException.' do
        expect { object }.to raise_error Makanai::Database::UnsupportedException
      end
    end
  end

  describe '#execute_sql' do
    before { allow(STDOUT).to receive(:puts) }

    it 'executable sql.' do
      db = Makanai::Database.new(
        client: :sqlite,
        config: { path: "#{root}/spec/db/makanai.db" }
      )
      expect(db.execute_sql('SELECT 1 AS val;')).to eq [{ 'val' => 1 }]
    end
  end
end
