# frozen_string_literal: true

require_relative './lib/application.rb'

@router.get '/' do
  'Hello Hey!!'
end

@router.get '/hoge' do
  'Hello Hoge!!'
end

@router.get '/check' do |params|
  params['hoge']
end
