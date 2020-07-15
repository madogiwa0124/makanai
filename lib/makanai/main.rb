# frozen_string_literal: true

require_relative './application'
require_relative './router'
require_relative './dsl'

def router
  @router ||= Makanai::Router.new
end

at_exit { Makanai::Application.new(router: @router).run! }
