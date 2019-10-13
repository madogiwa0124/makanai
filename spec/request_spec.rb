# frozen_string_literal: true

require 'ostruct'
require 'spec_helper'
require_relative '../lib/request'

describe Makanai::Request do
  describe '.initialize' do
    let(:env) do
      {
        'rack.url_scheme' => 'http',
        'SERVER_NAME' => 'example.org',
        'SERVER_PORT' => '8080',
        'PATH_INFO' => '/'
      }
    end

    context 'method GET with query parameter' do
      let(:get_env) do
        env.merge(
          'REQUEST_METHOD' => 'GET',
          'QUERY_STRING' => 'message=hello'
        )
      end

      it 'Successed build object' do
        req = Makanai::Request.new(get_env)
        expect(req.url).to eq 'http://example.org:8080/?message=hello'
        expect(req.origin_body).to eq nil
        expect(req.query).to eq 'message=hello'
        expect(req.params).to eq 'message' => 'hello'
        expect(req.method).to eq 'GET'
      end
    end

    context 'method POST with body' do
      let(:mock_body) { OpenStruct.new(read: 'message=hello') }
      let(:post_env) { env.merge('REQUEST_METHOD' => 'POST', 'rack.input' => mock_body) }
      let(:req) { Makanai::Request.new(post_env) }

      it 'Successed build object' do
        expect(req.url).to eq 'http://example.org:8080/'
        expect(req.query).to eq nil
        expect(req.origin_body).to eq 'message=hello'
        expect(req.params).to eq 'message' => 'hello'
        expect(req.method).to eq 'POST'
      end
    end

    context 'method POST with other method param' do
      let(:mock_body) { OpenStruct.new(read: 'message=hello&_method=PUT') }
      let(:put_env) { env.merge('REQUEST_METHOD' => 'POST', 'rack.input' => mock_body) }
      let(:req) { Makanai::Request.new(put_env) }

      it 'Successed build object' do
        expect(req.origin_body).to eq 'message=hello&_method=PUT'
        expect(req.params).to eq 'message' => 'hello'
        expect(req.method).to eq 'PUT'
      end
    end
  end

  describe '#root_url' do
    let(:env) do
      {
        'rack.url_scheme' => 'http',
        'SERVER_NAME' => 'example.org',
        'SERVER_PORT' => '8080',
        'PATH_INFO' => '/'
      }
    end

    it 'return root url' do
      root_url = Makanai::Request.new(env).root_url
      expect(root_url).to eq 'http://example.org:8080'
    end
  end
end
