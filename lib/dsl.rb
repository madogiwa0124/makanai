# frozen_string_literal: true

require_relative './template.rb'
require_relative './response.rb'
require_relative './settings.rb'

def render(path)
  template_root_path = "#{Dir.pwd}#{Makanai::Settings::TEMPLATE_ROOT_PATH}"
  full_path = "#{template_root_path}#{path}.erb"
  Makanai::Template.new(path: full_path).render
end

def redirect_to(url)
  Makanai::Response.new.tap do |response|
    response.status = 302
    response.header = { 'Location' => url }
  end
end
