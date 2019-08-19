# frozen_string_literal: true

require 'json'
require 'uri'
require 'rack'
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
      @request = Request.new(env)
      @response = Response.new
      route_result = execute_route
      return route_result.result if route_result.class == Response
      @response.body << execute_route
      @response.result
    end

    def execute_route
      router.bind!(url: request.url, method: request.method).process.call(request)
    rescue Makanai::Router::NotFound
      @response.status = 404
      nil
    end
  end

  class Request < Rack::Request
    def initialize(env)
      super
      @env = env
      @url = env['REQUEST_URI']
      @origin_body = body&.read
      @query = parsed_url.query
      @params = build_params
      @method = build_method
    end

    def root_url
      @root_url ||= "#{parsed_url.scheme}://#{parsed_url.host}:#{parsed_url.port}"
    end

    def parsed_body
      @parsed_body ||= JSON.parse(origin_body)
    rescue JSON::ParserError
      @parsed_body ||= origin_body.split('&').map { |param| param.split('=') }.to_h
    end

    def parsed_url
      @parsed_url ||= URI.parse(url)
    end

    def build_method
      return 'GET' if env['REQUEST_METHOD'] == 'GET'
      params&.delete('_method') || 'POST'
    end

    def build_params
      case env['REQUEST_METHOD']
      when 'GET'
        return Hash[URI.decode_www_form(query)] if query
      when 'POST'
        return parsed_body if origin_body
      end
    end

    attr_reader :env, :url, :query, :origin_body, :method, :params
  end

  class Response < Rack::Response
    def initialize
      super
      @header = { 'Content-Type' => 'text/html' }
    end

    attr_accessor :header

    def result
      [status, header, body.map(&:to_s)]
    end
  end
end
