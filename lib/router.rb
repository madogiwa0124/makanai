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

    def bind!(url:, method:)
      path = URI.parse(url).path
      routes.find { |route| route.path == path && route.method == method }.tap do |route|
        raise NotFound if route.nil?
      end
    end

    class Route
      def initialize(path:, process:, method:)
        @path = path
        @process = process
        @method = method
      end

      attr_reader :path, :process, :method
    end
  end
end
