# frozen_string_literal: true

require 'erb'
require 'yaml'
require_relative '../makanai'

module Makanai
  class Generator
    ROOT_PATH = "#{Makanai.root}/lib/makanai/generator"
    DIRECTORY_NAMES = YAML.load_file("#{ROOT_PATH}/application/directories.yaml")
    APP_TEMPLATE = File.read("#{ROOT_PATH}/application/templates/app.erb")
    RAKEFILE_TEMPLATE = File.read("#{ROOT_PATH}/application/templates/rakefile.erb")

    def initialize(path = Dir.pwd)
      @path = path
    end

    attr_reader :path

    def create_app_directories(directory_names = DIRECTORY_NAMES)
      directory_names.map do |name|
        dir_path = File.join(path, name)
        Dir.mkdir(dir_path)
        file_path = File.join(dir_path, '.keep')
        create_file(file_path, nil)
        file_path
      end
    end

    def create_app_rb(template = APP_TEMPLATE)
      File.join(path, 'app.rb').tap do |file_path|
        create_file(file_path, ERB.new(template).result)
      end
    end

    def create_rakefile(template = RAKEFILE_TEMPLATE)
      File.join(path, 'Rakefile').tap do |file_path|
        create_file(file_path, ERB.new(template).result)
      end
    end

    private

    def create_file(file_path, content)
      File.open(file_path, 'w') { |f| f.puts content }
    end
  end
end
