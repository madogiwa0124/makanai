# frozen_string_literal: true

require 'json'
require 'uri'
require 'rack'
require_relative './settings.rb'
require_relative './request.rb'
require_relative './response.rb'
require_relative './router.rb'

module Makanai
  class Application
    def initialize(router:)
      @router = router
      @config = Settings
    end

    attr_reader :router, :config, :request, :response

    def run!
      app_config = config.rack_app_config
      handler = Rack::Handler.get(app_config[:handler])
      handler.run(self, { Host: app_config[:host], Port: app_config[:port] })
    rescue Interrupt
      handler.shutdown
      puts '==== Goodbye! :) ===='
    end

    def call(env)
      @request = Makanai::Request.new(env)
      @response = Makanai::Response.new
      route_result = execute_route
      return route_result.result if route_result.class == Response
      @response.body << execute_route
      @response.result
    end

    private

    def execute_route
      route = router.bind!(url: request.url, method: request.method)
      # NOTE: merge dynamic url params (ex. /resources/1 -> { 'id' => '1' })
      @request.params.merge!(route.url_args)
      route.process.call(request)
    rescue Makanai::Router::NotFound
      @response.status = 404
      nil
    end
  end
end
