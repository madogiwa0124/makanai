# frozen_string_literal: true

require 'erb'

module Makanai
  class Template
    def initialize(path:)
      @path = path
    end

    attr_reader :path

    def render
      template_file = File.read(path)
      ERB.new(template_file).result
    end
  end
end
