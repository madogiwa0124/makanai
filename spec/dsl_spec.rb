# frozen_string_literal: true

require 'makanai/dsl'

RSpec.describe Makanai::Application do
  describe '#render' do
    # TODO: Not only be called, but also validate the rendered result.
    before do
      allow_any_instance_of(Makanai::Template)
        .to receive(:render)
        .and_return 'rendered'
    end

    it 'called Makanai::Template#render' do
      expect(render(:index)).to eq 'rendered'
    end
  end

  describe '#redirect_to' do
    it 'build redirect response.' do
      response = redirect_to 'http://example.org'
      expect(response.status).to eq 302
      expect(response.header).to eq 'Location' => 'http://example.org'
    end
  end
end
