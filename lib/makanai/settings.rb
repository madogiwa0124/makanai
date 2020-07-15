# frozen_string_literal: true

require 'rack'
require_relative './dbms/sqlite'
require_relative './dbms/postgres'

module Makanai
  class Settings
    DEFAULT_APP_ROOT_PATH = Dir.pwd
    DEFAULT_DATABASE_PATH = '/db/makanai.db'
    DEFAULT_TEMPLATE_ROOT_PATH = '/views/'
    DEFAULT_MIGRATION_ROOT_PATH = '/migration/'
    DEFAULT_RACK_APP_CONFIG = { handler: :webrick, host: '0.0.0.0', port: '8080' }.freeze
    DEFAULT_TEMPLATE_ENGINE = :erb

    @app_root_path = DEFAULT_APP_ROOT_PATH
    @database_path = DEFAULT_DATABASE_PATH
    @template_root_path = DEFAULT_TEMPLATE_ROOT_PATH
    @template_engine = DEFAULT_TEMPLATE_ENGINE
    @migration_root_path = DEFAULT_MIGRATION_ROOT_PATH
    @rack_app_config = DEFAULT_RACK_APP_CONFIG

    # NOTE: Use Sqlite3
    @databse_client = :sqlite
    @databse_config = { path: File.join(@app_root_path, @database_path) }

    # NOTE: Use Postgresql
    # @databse_client = :postgres
    # @databse_config = {
    #   host: 'localhost',
    #   password: 'password',
    #   dbname: 'makanai',
    #   port: 5432
    # }.freeze

    # NOTE: Use MySQL
    # @databse_client = :mysql
    # @databse_config = {
    #   host: 'localhost',
    #   username: 'root',
    #   password: 'password',
    #   database: 'makanai',
    #   port: 3306
    # }.freeze

    class << self
      attr_accessor :app_root_path,
                    :database_path,
                    :template_root_path,
                    :template_engine,
                    :migration_root_path,
                    :rack_app_config,
                    :databse_client,
                    :databse_config

      def database_full_path
        File.join(app_root_path, database_path)
      end

      def template_full_path
        File.join(app_root_path, template_root_path)
      end

      def migration_full_path
        File.join(app_root_path, migration_root_path)
      end
    end
  end
end
