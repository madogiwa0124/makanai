# frozen_string_literal: true

require_relative './template.rb'
require_relative './response.rb'
require_relative './settings.rb'

def render(path, engine = Makanai::Settings.template_engine)
  template_root_path = Makanai::Settings.template_full_path
  full_path = File.join(template_root_path, path.to_s)
  # NOTE: Get all instance variables in main by Hash
  locals = instance_variables.map { |name| [name, instance_variable_get(name)] }.to_h
  Makanai::Template.new(path: full_path, engine: engine, locals: locals).render
end

def redirect_to(url)
  Makanai::Response.new.tap do |response|
    response.status = 302
    response.header = { 'Location' => url }
  end
end
