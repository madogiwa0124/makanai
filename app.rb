# frozen_string_literal: true

require_relative './lib/main.rb'
require_relative './src/models/number.rb'

router.get '/' do
  'Hello Makanai!'
end

router.get '/hoge' do
  'Hello Hoge!!'
end

router.get '/check' do |params|
  params['hoge']
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
