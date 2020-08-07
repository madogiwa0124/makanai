# frozen_string_literal: true

require 'makanai/generator'

RSpec.describe Makanai::Generator do
  before do
    allow(File).to receive(:open).and_return('called File.open')
    allow(Dir).to receive(:mkdir).and_return('called Dir.mkdir')
  end

  describe '#create_app_directories' do
    let(:generator) { Makanai::Generator.new('/') }

    it 'return created keep path in directries.' do
      result = generator.create_app_directories
      expect(result).to match_array [
        File.join('/', 'db', '.keep'),
        File.join('/', 'views', '.keep'),
        File.join('/', 'models', '.keep'),
        File.join('/', 'migration', '.keep')
      ]
    end
  end

  describe '#create_app_rb' do
    let(:generator) { Makanai::Generator.new('/') }

    it 'return created app file path.' do
      result = generator.create_app_rb
      expect(result).to eq File.join('/', 'app.rb')
    end
  end

  describe '#create_rakefile' do
    let(:generator) { Makanai::Generator.new('/') }

    it 'return created Rakefile path.' do
      result = generator.create_rakefile
      expect(result).to eq File.join('/', 'Rakefile')
    end
  end

  describe '#create_gemfile' do
    let(:generator) { Makanai::Generator.new('/') }

    it 'return created Rakefile path.' do
      result = generator.create_gemfile
      expect(result).to eq File.join('/', 'Gemfile')
    end
  end
end
