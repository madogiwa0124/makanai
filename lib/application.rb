# frozen_string_literal: true

require 'rack'
require_relative './router.rb'

module Makanai
  class Application
    attr_accessor :env

    def run!
      app = proc do |env|
        @env = env
        ['200', { 'Content-Type' => 'text/html' }, ['Hello Rack']]
      end
      Rack::Handler::WEBrick.run app
    end
  end
end

at_exit { Makanai::Application.new.run! }
