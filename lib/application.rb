require 'rack'

module Makanai
  class Application
    def run!
      app = Proc.new do |env|
        ['200', {'Content-Type' => 'text/html'}, ["Hello Rack"]]
      end
      Rack::Handler::WEBrick.run app
    end
  end
end

at_exit { Makanai::Application.new.run! }
