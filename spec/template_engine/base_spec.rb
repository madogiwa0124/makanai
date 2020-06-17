# frozen_string_literal: true

require 'makanai/template_engine/base'

RSpec.describe Makanai::TemplateEngine::Base do
  describe '#result' do
    it 'raise NotImplementedError' do
      engine = Makanai::TemplateEngine::Base.new
      expect { engine.result }.to raise_error NotImplementedError
    end
  end
end
