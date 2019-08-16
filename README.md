# Makanai
simple web application framework for learning.

# Usage

create a ruby ​​file(ex. app.rb).

``` ruby
require_relative './lib/main.rb'

router.get '/' do
  'Hello Makanai!'
end
```

start server(WEBrick) at  execute `$ ruby app.rb`.

```
$ ruby app.rb
[2019-08-12 20:44:20] INFO  WEBrick 1.4.2
[2019-08-12 20:44:20] INFO  ruby 2.6.3 (2019-04-16) [x86_64-darwin18]
[2019-08-12 20:44:20] INFO  WEBrick::HTTPServer#start: pid=26043 port=8080
```

When accessing root, `Hello Makanai!` is displayed.

## routing

``` ruby
require_relative './lib/main.rb'

# root path
router.get '/' do
  'Hello Makanai!'
end

# enable access to /hoge
router.get '/hoge' do
  'Hello Hoge!'
end

# enable access to /params with get parameter
router.get '/check' do |params|
  params['hoge']
end

# TODO: post
router.post '/resources' do |params|
end

# TODO: patch
router.patch '/resources/:id' do |params|
end
```

## erb render

Define instance variables used in the routing view.

``` ruby
require_relative './lib/main.rb'

router.get '/index' do
  @title = 'Makanai title'
  @body = 'Makanai body'
  render :index
end
```

Create an erb file in `src/views` with the name specified in render.

``` html
<!-- src/views/index.erb -->
<html>
<head>
  <meta charset="UTF-8">
  <title><%= @title %></title>
</head>
<body>
  <%= @body %>
</body>
</html>
```

## migration

makanai uses `sqlite3` as db. create db and migrate schema when executed `rake makanai:db:migrate`.

```
# execute all migraiton sql
$ rake makanai:db:migrate target=all

# execute migraiton target sql
$ rake makanai:db:migration target=20190816_1_create_numbers.sql
```

display information when excuted migration.

```
$ rake makanai:db:migration target=all
INFO: start migration all
execute: makanai/src/migration/20190816_1_create_numbers.sql
create table numbers (
  name varchar(30),
  val int
);
execute: makanai/src/migration/20190816_2_drop_numbers.sql
drop table numbers;
INFO: finished migration all
```
