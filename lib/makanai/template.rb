# frozen_string_literal: true

module Makanai
  class Template
    class UnsupportedException < StandardError; end

    def initialize(path:, engine: :erb, locals: {})
      @path = path
      @engine = engine
      @locals = locals
    end

    attr_reader :path, :engine, :locals

    def render
      template_file = File.read("#{path}.#{engine}")
      engine_class.new(text: template_file, locals: locals).result
    end

    private

    def engine_class
      require_relative File.join('template_engine', engine.to_s)
      Object.const_get("Makanai::TemplateEngine::#{engine.capitalize}")
    rescue LoadError
      raise UnsupportedException
    end
  end
end
