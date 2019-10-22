# frozen_string_literal: true

require_relative './application.rb'
require_relative './router.rb'
require_relative './dsl.rb'

def router
  @router ||= Makanai::Router.new
end

at_exit { Makanai::Application.new(router: @router).run! }
