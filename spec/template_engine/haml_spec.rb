# frozen_string_literal: true

require 'makanai/template_engine/haml'

RSpec.describe Makanai::TemplateEngine::Haml do
  describe '#result' do
    let(:locals) { { :@foo => 'foo' } }
    let(:text) { '%span= @foo' }

    it 'return parsed haml text' do
      result = Makanai::TemplateEngine::Haml.new(text: text, locals: locals).result
      expect(result).to eq "<span>foo</span>\n"
    end
  end
end
