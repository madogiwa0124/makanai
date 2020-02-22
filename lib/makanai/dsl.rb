# frozen_string_literal: true

require_relative './template.rb'
require_relative './response.rb'
require_relative './settings.rb'

def render(path)
  template_root_path = Makanai::Settings.template_full_path
  full_path = File.join(template_root_path, "#{path}.erb")
  Makanai::Template.new(path: full_path).render
end

def redirect_to(url)
  Makanai::Response.new.tap do |response|
    response.status = 302
    response.header = { 'Location' => url }
  end
end
