# Makanai
simple web application framework for learning

# Usage

create a ruby ​​file(ex. app.rb).

``` ruby
require_relative './lib/application.rb'

@router.get '/' do
  'Hello Makanai!!'
end
```

start server(WEBrick) at  execute `$ ruby app.rb`.

```
$ ruby app.rb
[2019-08-12 20:44:20] INFO  WEBrick 1.4.2
[2019-08-12 20:44:20] INFO  ruby 2.6.3 (2019-04-16) [x86_64-darwin18]
[2019-08-12 20:44:20] INFO  WEBrick::HTTPServer#start: pid=26043 port=8080
```

When accessing root, `Hello Makanai!!` is displayed.

## routing

``` ruby
require_relative './lib/application.rb'

# root path
@router.get '/' do
  'Hello Hey!!'
end

# enable access to /hoge
@router.get '/hoge' do
  'Hello Hoge!!'
end

# enable access to /check with get parameter
@router.get '/check' do |params|
  params['hoge']
end

# TODO: post
@router.post '/resources' do |params|
end

# TODO: patch
@router.patch '/resources' do |params|
end
```

## erb render

comming soon...

## db access and migration

comming soon...
