# frozen_string_literal: true

module Makanai
  module TemplateEngine
    class Base
      def result
        raise NotImplementedError
      end
    end
  end
end
