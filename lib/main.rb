# frozen_string_literal: true

require_relative './template.rb'
require_relative './router.rb'
require_relative './response.rb'
require_relative './application.rb'
require_relative '../config/settings.rb'

def render(path)
  template_root_path = "#{Dir.pwd}#{Makanai::Settings::TEMPLATE_ROOT_PATH}"
  full_path = "#{template_root_path}#{path}.erb"
  Makanai::Template.new(path: full_path).render
end

def router
  @router ||= Makanai::Router.new
end

def redirect_to(url)
  Makanai::Response.new.tap do |response|
    response.status = 302
    response.header = { 'Location' => url }
  end
end

at_exit { Makanai::Application.new(router: @router).run! }
