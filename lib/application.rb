# frozen_string_literal: true

require 'json'
require 'uri'
require 'rack'
require_relative './request.rb'
require_relative './response.rb'
require_relative './router.rb'

module Makanai
  class Application
    def initialize(router:)
      @router = router
      @handler = Rack::Handler::WEBrick
    end

    attr_reader :router, :handler, :request, :response

    def run!
      handler.run self
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
      router.bind!(url: request.url, method: request.method).process.call(request)
    rescue Makanai::Router::NotFound
      @response.status = 404
      nil
    end
  end
end
