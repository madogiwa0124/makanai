# frozen_string_literal: true

require 'ostruct'
require 'spec_helper'
require_relative '../lib/response'

describe Makanai::Response do
  describe '.initialize' do
    let(:response) { Makanai::Response.new }

    it 'default content type is html' do
      expect(response.header['Content-Type']).to eq 'text/html'
    end
  end

  describe '#result' do
    let(:response) { Makanai::Response.new }

    before do
      response.status = 200
      response.header = { 'Content-Type' => 'text/json' }
      response.body = ['hello']
    end

    it 'return array in status, header, body' do
      expect(response.result).to eq [
        200, { 'Content-Type' => 'text/json' }, ['hello']
      ]
    end
  end
end
