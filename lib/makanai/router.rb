# frozen_string_literal: true

require 'uri'

module Makanai
  class Router
    class NotFound < StandardError; end

    attr_accessor :routes

    def initialize
      @routes = []
    end

    def get(path, &block)
      @routes << Route.new(path: path, process: block, method: 'GET')
    end

    def post(path, &block)
      @routes << Route.new(path: path, process: block, method: 'POST')
    end

    def put(path, &block)
      @routes << Route.new(path: path, process: block, method: 'PUT')
    end

    def delete(path, &block)
      @routes << Route.new(path: path, process: block, method: 'DELETE')
    end

    def bind!(url:, method:)
      path = URI.parse(url).path
      routes.find { |route| route.match?(path: path, method: method) }.tap do |route|
        raise NotFound if route.nil?
      end
    end

    class Route
      DYNAMIC_PREFIX = ':' # Prefix for dynamic path

      def initialize(path:, process:, method:)
        @path = path
        @process = process
        @method = method
        @url_args = {}
      end

      attr_reader :path, :process, :method, :url_args

      def match?(path:, method:)
        build_url_args(path: path)
        path_match?(path) && self.method == method
      end

      private

      def dynamic_indx
        @dynamic_indx ||= path.split('/').map.with_index do |val, i|
          i if val.include?(DYNAMIC_PREFIX)
        end.compact
      end

      def path_match?(path)
        request_path, route_path = [path, self.path].map(&->(array) { array.split('/') })
        request_path.each.with_index do |val, i|
          route_path[i] = val if dynamic_indx.include?(i)
        end
        route_path == request_path
      end

      def build_url_args(path:)
        request_path, route_path = [path, self.path].map(&->(array) { array.split('/') })
        dynamic_indx.each do |i|
          @url_args.merge!({ route_path[i].gsub(DYNAMIC_PREFIX, '') => request_path[i] })
        end
      end
    end
  end
end
