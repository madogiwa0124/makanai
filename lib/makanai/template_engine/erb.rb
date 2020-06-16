# frozen_string_literal: true

require 'erb'
require 'ostruct'
require_relative './base'

module Makanai
  module TemplateEngine
    class Erb < Base
      def initialize(text:, locals: {})
        @text = text
        @locals = locals
      end

      attr_reader :text, :locals

      def result
        # NOTE: ERB is need to pass the binding.
        # So, pass the binding of the object that defined the instance variable.
        # ref: https://docs.ruby-lang.org/en/2.7.0/ERB.html#method-i-result
        ERB.new(text).result(Locals.new(locals).self_binding)
      end
      class Locals
        def initialize(locals)
          locals.each { |key, val| instance_variable_set(key, val) }
        end

        def self_binding
          binding
        end
      end

      private_constant :Locals
    end
  end
end
