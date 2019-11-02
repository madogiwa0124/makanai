# frozen_string_literal: true

require 'makanai/database'
require 'makanai/model'
require 'makanai/database'
require 'makanai/settings'

RSpec.describe Makanai::Model do
  let(:root) { Makanai::Settings::APP_ROOT_PATH }

  class SampleModel < Makanai::Model
    TABLE_NAME = 'numbers'
    PRYMARY_KEY = 'id'
  end

  describe '.initialize' do
    let(:attributes) { { id: 1, body: 'hoge' } }
    let(:model) { SampleModel.new(attributes) }

    it 'difined get attributes methods.' do
      expect(model.id).to eq 1
      expect(model.body).to  eq 'hoge'
    end

    it 'difined set attributes methods.' do
      model.id = 2
      model.body = 'fuga'
      expect(model.id).to eq 2
      expect(model.body).to eq 'fuga'
    end

    it 'set origin attributes.' do
      expect(model.origin_attributes).to eq attributes
    end
  end

  describe 'query methods' do
    let(:create_table_sql) { File.read("#{root}/spec/migration/create_numbers.sql") }
    let(:drop_table_sql) { File.read("#{root}/spec/migration/drop_numbers.sql") }

    def build_db
      Makanai::Database.new(path: "#{root}/spec/db/makanai.db")
    end

    def create_number_sql(id, name, val)
      "INSERT INTO numbers VALUES (#{id}, '#{name}', '#{val}')"
    end

    before do
      allow(STDOUT).to receive(:puts)
      build_db.execute_sql create_table_sql
      build_db.execute_sql create_number_sql(1, 'name_1', 'val_1')
      build_db.execute_sql create_number_sql(2, 'name_2', 'val_2')
      build_db.execute_sql create_number_sql(3, 'name_3', 'val_3')
    end

    after { build_db.execute_sql drop_table_sql }

    describe '.execute_sql' do
      let(:db) { build_db }
      before { allow(db).to receive(:execute_sql).and_return('success') }

      it 'called db executed sql' do
        expect(SampleModel.execute_sql('sql', db)).to eq 'success'
      end
    end

    describe '.all' do
      it 'return model object.' do
        expect(SampleModel.all(build_db).map(&:class)).to eq [
          SampleModel,
          SampleModel,
          SampleModel
        ]
      end

      it 'return all records.' do
        expect(SampleModel.all(build_db).map(&:origin_attributes)).to eq [
          { 'id' => 1, 'name' => 'name_1', 'val' => 'val_1' },
          { 'id' => 2, 'name' => 'name_2', 'val' => 'val_2' },
          { 'id' => 3, 'name' => 'name_3', 'val' => 'val_3' }
        ]
      end
    end

    describe '.find' do
      context 'record found' do
        it 'return model object.' do
          expect(SampleModel.find(2, build_db).class).to eq SampleModel
        end

        it 'return found record.' do
          target_attributes = { 'id' => 2, 'name' => 'name_2', 'val' => 'val_2' }
          expect(SampleModel.find(2, build_db).origin_attributes).to eq target_attributes
        end
      end

      context 'record not found' do
        it 'raise not found.' do
          expect { SampleModel.find(0, build_db) }.to raise_error Makanai::Model::NotFound
        end
      end
    end

    describe '.last' do
      it 'return model object.' do
        expect(SampleModel.last(build_db).class).to eq SampleModel
      end

      it 'return last record by primary key.' do
        expect(SampleModel.last(build_db).id).to eq 3
      end
    end

    describe '.first' do
      it 'return model object.' do
        expect(SampleModel.first(build_db).class).to eq SampleModel
      end

      it 'return first record by primary key.' do
        expect(SampleModel.first(build_db).id).to eq 1
      end
    end

    describe '#create' do
      let(:select_sql) { 'SELECT * FROM numbers WHERE id = 5;' }

      it 'return model object.' do
        object = SampleModel.new(id: 5, name: 'name', val: 'val')
        expect(object.create(build_db).class).to eq SampleModel
      end

      it 'insert record.' do
        SampleModel.new(id: 5, name: 'name', val: 'val').create(build_db)
        result = { 'id' => 5, 'name' => 'name', 'val' => 'val' }
        expect(build_db.execute_sql(select_sql).pop).to eq result
      end
    end

    describe '#update' do
      before { build_db.execute_sql create_number_sql(5, 'name', 'val') }

      it 'return model object.' do
        object = SampleModel.new(id: 5, name: 'hoge', val: 'fuga')
        expect(object.update(build_db).class).to eq SampleModel
      end

      it 'update origin_attributes.' do
        object = SampleModel.new(id: 5, name: 'hoge', val: 'fuga').update(build_db)
        result = { id: 5, name: 'hoge', val: 'fuga' }
        expect(object.origin_attributes).to eq result
      end

      it 'update record.' do
        object = SampleModel.new(id: 5, name: 'hoge', val: 'fuga').update(build_db)
        expect(object.name).to eq 'hoge'
        expect(object.val).to eq 'fuga'
      end
    end

    describe '#delete' do
      let(:select_sql) { 'SELECT * FROM numbers WHERE id = 5;' }
      before { build_db.execute_sql create_number_sql(5, 'name', 'val') }

      it 'return nil' do
        object = SampleModel.new(id: 5, name: 'hoge', val: 'fuga')
        expect(object.delete(build_db)).to eq nil
      end

      it 'delete record.' do
        SampleModel.new(id: 5, name: 'hoge', val: 'fuga').delete(build_db)
        expect(build_db.execute_sql(select_sql)).to eq []
      end
    end
  end

  describe '.buid_sql_text' do
    context 'arg is String' do
      it 'return escaped single quarto string' do
        expect(SampleModel.buid_sql_text("'hoge'")).to eq "'''hoge'''"
      end
    end

    context 'arg is Intger or Numeric' do
      it 'return value' do
        expect(SampleModel.buid_sql_text(1)).to eq 1
      end
    end
  end

  describe '#assign_attributes' do
    it 'return attributes assigned object' do
      object = SampleModel.new(name: 'hoge', val: 'fuga')
      object.assign_attributes(name: 'piyo', val: 'moge')
      expect(object.name).to eq 'piyo'
      expect(object.val).to eq 'moge'
    end
  end

  describe '#attributes' do
    it 'return object attributes' do
      attributes ={ name: 'hoge', val: 'fuga' }
      expect(SampleModel.new(attributes).attributes).to eq  attributes
    end
  end
end
