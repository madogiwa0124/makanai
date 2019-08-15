# frozen_string_literal: true

require_relative './template.rb'
require_relative './router.rb'
require_relative './application.rb'

TEMPLATE_ROOT_PATH = '/src/views/'

def render(path)
  template_root_path = "#{Dir.pwd}#{TEMPLATE_ROOT_PATH}"
  full_path = "#{template_root_path}#{path}.erb"
  Makanai::Template.new(path: full_path).render
end

def router
  @router ||= Makanai::Router.new
end

at_exit { Makanai::Application.new(router: @router).run! }
