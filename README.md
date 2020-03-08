# Makanai

[![Gem Version](https://badge.fury.io/rb/makanai.svg)](https://badge.fury.io/rb/makanai)
[![Build Status](https://travis-ci.com/Madogiwa0124/makanai.svg?branch=master)](https://travis-ci.com/Madogiwa0124/makanai)
[![codecov](https://codecov.io/gh/Madogiwa0124/makanai/branch/master/graph/badge.svg)](https://codecov.io/gh/Madogiwa0124/makanai)

simple web application framework for learning.

# Getting Start

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'makanai'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install makanai

## Dependencies

Makanai depends on the following, so please install it in advance.

* [SQLite3](https://www.sqlite.org/index.html)

## Start sample project
Getting started with Makanai is easy.

```
$ mkdir sample
$ cd sample
$ makanai init
$ ruby app.rb
[2019-12-28 12:27:13] INFO  WEBrick 1.6.0
[2019-12-28 12:27:13] INFO  ruby 2.7.0 (2019-12-25) [x86_64-darwin18]
[2019-12-28 12:27:13] INFO  WEBrick::HTTPServer#start: pid=22676 port=8080
```

# Usage

create a ruby ​​file(ex. app.rb).

``` ruby
require 'makanai/main'

router.get '/' do
  'Hello Makanai!'
end
```

start server(WEBrick) at  execute `$ ruby app.rb`.

```
$ ruby app.rb
[2019-12-28 12:27:13] INFO  WEBrick 1.6.0
[2019-12-28 12:27:13] INFO  ruby 2.7.0 (2019-12-25) [x86_64-darwin18]
[2019-12-28 12:27:13] INFO  WEBrick::HTTPServer#start: pid=22676 port=8080
```

When accessing root, `Hello Makanai!` is displayed.

## constitution
Makanai application has the following constitution.

```
root ┬ app.rb    # main application file
     ├ views     # views files(ex. index.erb)
     ├ models    # models files(ex. post.rb)
     ├ migration # migration files(ex. 00_create_resources.sql)
     └ db        # use Sqlite3 dabase file
```

## override application config

You can overwrite the settings (`Makanai :: Settings`) with the created ruby ​​file(ex. app.rb).

ex) When overriding rack app settings.

``` ruby
Makanai::Settings.rack_app_config = { handler: :webrick, host: '0.0.0.0', port: '8081' }
```

### use other application server

Add rack web server(ex. puma) gem in your Gemfile.

``` ruby
gem 'puma'
```

Overwrite the `handler` in `rack_app_config` with the created ruby ​​file(ex. app.rb).

``` ruby
Makanai::Settings.rack_app_config = { handler: :puma, host: '0.0.0.0', port: '8080' }
```

### use other dbms

install dbms(postgresql, mysql, sqlite). And add dbms gem (ex. pg) in your Gemfile.

``` ruby
gem 'pg'
```

Overwrite the `databse_client` and `databse_config` with the created ruby ​​file(ex. app.rb) and Rakefile.

``` ruby
Makanai::Settings.databse_client = :postgres
Makanai::Settings.databse_config = {
  host: 'localhost',
  password:'password',
  dbname: 'makanai',
  port: 5432
}
```

## routing
Routing is searched in the order defined and call block args.

``` ruby
require 'makanai/main'

# root path
router.get '/' do
  'Hello Makanai!'
end

# enable access to /hoge
router.get '/hoge' do
  'Hello Hoge!'
end

# enable access to /hoge with get parameter(?hoge=fuga)
router.get '/hoge' do |request|
  request.params['hoge']
end

# enable access to /hoge/:id with dinamic url args({ 'id' => '1'})
# NOTE: dinamics prefix is `:`.
router.get '/hoge/:id' do
  request.params['id']
end

# enable access to /resources with method post and redirect other url.
router.post '/resources' do |request|
  Resource.new(request.params).create
  redirect_to("#{request.root_url}/resources")
end

# enable access to /resources with method put and redirect other url.
router.put '/resources' do |request|
  resource = Resource.find(request.params['id'])
  resource.assign_attributes(request.params).update
  redirect_to("#{request.root_url}/resources")
end

# enable access to /resources with method delete and redirect other url.
router.delete '/resources' do |request|
  resource = Resource.find(request.params['id'])
  resource.assign_attributes(request.params).delete
  redirect_to("#{request.root_url}/resources")
end
```

## erb render

Define instance variables used in the routing view.

``` ruby
require 'makanai/main'

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

migrate schema when executed `rake makanai:db:migration`.

```
# execute all migraiton sql
$ rake makanai:db:migration target=all

# execute migraiton target sql
$ rake makanai:db:migration target=20190816_1_create_resource.sql
```

display information when excuted migration.

```
$ rake makanai:db:migration target=all
INFO: start migration all
execute: makanai/src/migration/20190816_1_create_resources.sql
create table resources (
  name varchar(30),
  val int
);
execute: makanai/src/migration/20190816_2_drop_resources.sql
drop table resources;
INFO: finished migration all
```

## model
`Makanai::Model` is simple ORM.
It can be used by creating a class that inherits `Makanai::Model`.

``` ruby
require 'makanai/model'

class Resource < Makanai::Model
  # target table when executing sql.
  TABLE_NAME = 'resources'
  # primary key of the table.
  PRYMARY_KEY = 'id'
end

# execute `select * from resources;` and get all records.
Resource.all
#=> [
#     #<Resource:0x00007fc967a7c578 @origin_attributes={"id"=>1, "name"=>"one", "val"=>1}, @id=1, @name="one", @val=1>
#     #<Resource:0x00007ffa55a60520 @origin_attributes={"id"=>2, "name"=>"two", "val"=>2}, @id=2, @name="two", @val=2>
#   ]

# execute `select * from resources where id = 1 LIMIT 1` and get record.
Resource.find(1)
#=> #<Resource:0x00007ffa5509f400 @origin_attributes={"id"=>1, "name"=>"one", "val"=>1}, @id=1, @name="one", @val=1>

# execute `insert into resources(name, val) values ('one', 1);`
Resource.new(name: 'one', val: 1).create
#=> #<Resource:0x00007fca1c160dd0 @origin_attributes={"id"=>1, "name"=>"one", "val"=>1}, @id=1, @name="one", @val=1>

# execute `update resources set id=1, name='eins',val=1 where id = 1;`
Resource.find(1).tap { |num| num.name = 'eins' }.update
#=> #<Resource:0x00007fca1c160dd0 @origin_attributes={"id"=>2, "name"=>"zwei", "val"=>2}, @id=6, @name="zwei", @val=2>

# execute `delete from resources where id = 1;`
Resource.find(1).delete
#=> nil
```

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Madogiwa0124/makanai. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## setup develop enviroment

Use docker-compose to build `mysql` and` postgres` containers for development.

``` sh
$ docker-compose up -d
Creating makanai_mysql_1    ... done
Creating makanai_postgres_1 ... done

$ docker-compose ps
       Name                     Command              State                 Ports
----------------------------------------------------------------------------------------------
makanai_mysql_1      docker-entrypoint.sh mysqld     Up      0.0.0.0:3306->3306/tcp, 33060/tcp
makanai_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp
```

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

# Code of Conduct

Everyone interacting in the makanai project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Madogiwa0124/makanai/blob/master/CODE_OF_CONDUCT.md).
