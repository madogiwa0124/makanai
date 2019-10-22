# frozen_string_literal: true

require 'rack'

module Makanai
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
