# frozen_string_literal: true

require 'haml'
require_relative './base'

module Makanai
  module TemplateEngine
    class Haml < Base
      def initialize(text:, locals: {})
        @text = text
        @locals = locals
      end

      attr_reader :text, :locals

      def result
        # ref: http://haml.info/docs/yardoc/Haml/Engine.html#render-instance_method
        ::Haml::Engine.new(text).render(Object.new, locals)
      end
    end
  end
end
