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
    before { router.get('/') { 'Hello World!' } }

    it 'Success Hellow World' do
      response = Rack::MockRequest.new(app).get('/')
      expect(response.status).to eq 200
      expect(response.body).to eq 'Hello World!'
    end

    context 'has query parameter' do
      let(:response) { Rack::MockRequest.new(app).get('/hello?message=Makanai') }
      before { router.get('/hello') { |req| "Hello #{req.params['message']}!" } }

      it 'Response Successed' do
        expect(response.status).to eq 200
      end

      it 'return message with query parameter' do
        expect(response.body).to eq 'Hello Makanai!'
      end
    end

    context 'routing not found' do
      let(:response) { Rack::MockRequest.new(app).get('/notfound') }

      it 'return status 404' do
        expect(response.status).to eq 404
      end
    end
  end
end
