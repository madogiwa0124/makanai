# frozen_string_literal: true

require 'makanai/template_engine/erb'

RSpec.describe Makanai::TemplateEngine::Erb do
  describe '#result' do
    let(:text) { '<span><%= @foo %></span>' }
    let(:locals) { { :@foo => 'foo' } }

    it 'return parsed erb text' do
      result = Makanai::TemplateEngine::Erb.new(text: text, locals: locals).result
      expect(result).to eq '<span>foo</span>'
    end
  end
end
