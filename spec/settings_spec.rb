# frozen_string_literal: true

require 'ostruct'
require 'makanai/settings'

RSpec.describe Makanai::Settings do
  describe 'initialize class' do
    it 'configured default attributes', aggregate_failures: true do
      rack_app_config = { handler: :webrick, host: '0.0.0.0', port: '8080' }
      expect(Makanai::Settings.app_root_path).to eq Dir.pwd
      expect(Makanai::Settings.database_path).to eq '/db/makanai.db'
      expect(Makanai::Settings.template_root_path).to eq '/views/'
      expect(Makanai::Settings.migration_root_path).to eq '/migration/'
      expect(Makanai::Settings.rack_app_config).to eq rack_app_config
    end
  end

  describe '.database_full_path' do
    let(:settings) { Makanai::Settings }

    before do
      settings.app_root_path = '/app/root'
      settings.database_path = '/database'
    end

    it 'return database_path joined app_root_path' do
      expect(settings.database_full_path).to eq '/app/root/database'
    end
  end

  describe '.template_full_path' do
    let(:settings) { Makanai::Settings }

    before do
      settings.app_root_path = '/app/root'
      settings.template_root_path = '/templates'
    end

    it 'return template_root_path joined app_root_path' do
      expect(settings.template_full_path).to eq '/app/root/templates'
    end
  end

  describe '.migration_full_path' do
    let(:settings) { Makanai::Settings }

    before do
      settings.app_root_path = '/app/root'
      settings.migration_root_path = '/migrate'
    end

    it 'return migration_root_path joined app_root_path' do
      expect(settings.migration_full_path).to eq '/app/root/migrate'
    end
  end
end
