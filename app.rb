# frozen_string_literal: true

require_relative './lib/main.rb'
require_relative './src/models/number.rb'

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
