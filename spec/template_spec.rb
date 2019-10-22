# frozen_string_literal: true

require 'ostruct'
require 'makanai/template'

RSpec.describe Makanai::Template do
  describe '#render' do
    let(:template) { Makanai::Template.new(path: 'test.erb') }
    let(:erb_text) { 'result: <%= 1+1 %>' }
    before { allow(File).to receive(:read).and_return(erb_text) }

    it 'return parsed erb text' do
      expect(template.render).to eq 'result: 2'
    end
  end
end
