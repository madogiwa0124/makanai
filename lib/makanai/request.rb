# frozen_string_literal: true

require 'json'
require 'rack'
require 'uri'

module Makanai
  class Request < Rack::Request
    attr_reader :env, :url, :query, :origin_body, :method
    attr_accessor :params

    def initialize(env)
      super
      @env = env
      @url = build_url
      @origin_body = body&.read
      @query = parsed_url.query
      @params = build_params
      @method = build_method
    end

    def root_url
      @root_url ||= "#{parsed_url.scheme}://#{parsed_url.host}:#{parsed_url.port}"
    end

    private

    def build_url
      root = "#{env['rack.url_scheme']}://#{env['SERVER_NAME']}"
      root += ":#{env['SERVER_PORT']}#{env['PATH_INFO']}"
      env['QUERY_STRING'] ? (root + "?#{env['QUERY_STRING']}") : root
    end

    def parsed_body
      @parsed_body ||= JSON.parse(origin_body)
    rescue JSON::ParserError
      @parsed_body ||= origin_body.split('&').to_h { |param| param.split('=') }
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
        return URI.decode_www_form(query).to_h if query
      when 'POST'
        return parsed_body if origin_body
      end
    end
  end
end
