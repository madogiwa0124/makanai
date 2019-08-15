# frozen_string_literal: true

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
      @response.body << execute_route
      @response.result
    end

    def execute_route
      router.bind!(url: request.url, method: request.method).process.call(request.params)
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
      @query = URI.parse(url).query
    end

    def params
      return unless query
      @params ||= Hash[URI.decode_www_form(query)]
    end

    attr_reader :url, :method, :query
  end

  class Response < Rack::Response
    def initialize
      super
      @header = { 'Content-Type' => 'text/html' }
    end

    def result
      [status, header, body.map(&:to_s)]
    end
  end
end
