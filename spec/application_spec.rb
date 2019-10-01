# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/application.rb'

describe Makanai::Application do
  it 'respond to call.' do
    expect(Makanai::Application.new(router: nil)).to respond_to :call
  end

  describe '#call' do
    let(:router) { Makanai::Router.new }
    let(:app) { Makanai::Application.new(router: router) }
    before { router.get('/') { 'Hello Makanai!' } }

    it 'Success Hellow World' do
      response = Rack::MockRequest.new(app).get('/')
      expect(response.status).to eq 200
      expect(response.body).to eq 'Hello Makanai!'
    end
  end
end
