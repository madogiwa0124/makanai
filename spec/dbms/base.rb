# frozen_string_literal: true

require 'makanai/dbms/base'
require 'makanai/settings'

RSpec.describe Makanai::Dbms::Base do
  context 'override methods' do
    it 'return overrided method result.' do
      klass = Class.new(Makanai::Dbms::Base) do
        define_method(:db) { 'db' }
        define_method(:execute_sql) { 'execute_sql' }
      end
      expect(klass.new.db).to eq 'db'
      expect(klass.new.execute_sql).to eq 'execute_sql'
    end
  end

  context 'not override db' do
    it 'raised NotImplementedError' do
      klass = Class.new(Makanai::Dbms::Base) do
        define_method(:execute_sql) { 'execute_sql' }
      end
      expect { klass.new.db }.to raise_error NotImplementedError
    end
  end

  context 'not override execute_sql' do
    it 'raised NotImplementedError' do
      klass = Class.new(Makanai::Dbms::Base) do
        define_method(:db) { 'db' }
      end
      expect { klass.new.execute_sql }.to raise_error NotImplementedError
    end
  end
end
