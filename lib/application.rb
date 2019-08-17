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
      @url = env['REQUEST_URI']
      @method = env['REQUEST_METHOD']
      @root_url = "#{parsed_url.scheme}://#{parsed_url.host}:#{parsed_url.port}"
      @query = parsed_url.query
    end

    def parsed_url
      @parsed_url ||= URI.parse(url)
    end

    def params
      case method
      when 'GET'
        return unless query
        @params ||= Hash[URI.decode_www_form(query)]
      when 'POST'
        post_params = body.read
        return if post_params.empty?
        begin
          @params ||= JSON.parse(post_params)
        rescue JSON::ParserError
          @params ||= post_params.split('&').map { |param| param.split('=') }.to_h
        end
      end
    end

    attr_reader :url, :method, :root_url, :query
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
