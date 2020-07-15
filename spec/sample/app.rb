# frozen_string_literal: true

require 'makanai/main'
require_relative './models/number'

router.get '/' do
  'Hello Makanai!'
end

router.get '/hoge' do
  'Hello Hoge!!'
end

router.get '/check' do |request|
  request.params['hoge']
end

router.get '/index' do
  @title = 'Makanai title'
  @body = 'Makanai body'
  render :index
end

router.get '/index/haml' do
  @title = 'Makanai title'
  @body = 'Makanai body'
  render :index, :haml
end

router.get '/numbers' do
  @title = 'numbers'
  @numbers = Number.all
  render :numbers
end

router.post '/numbers' do |request|
  Number.new(request.params).create
  redirect_to("#{request.root_url}/numbers")
end

router.put '/numbers' do |request|
  number = Number.find(request.params['id'])
  number.assign_attributes(request.params).update
  redirect_to("#{request.root_url}/numbers")
end

router.delete '/numbers' do |request|
  number = Number.find(request.params['id'])
  number.assign_attributes(request.params).delete
  redirect_to("#{request.root_url}/numbers")
end
