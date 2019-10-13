# Makanai
simple web application framework for learning.

# Getting Start

## Dependencies

Makanai depends on the following, so please install it in advance.

* [SQLite3](https://www.sqlite.org/index.html)

## Start sample project
Getting started with Makanai is easy.

```
$ git clone https://github.com/Madogiwa0124/makanai.git
$ bundle install
$ cd makanai/sample
$ be ruby app.rb
[2019-09-09 23:20:05] INFO  WEBrick 1.4.2
[2019-09-09 23:20:05] INFO  ruby 2.6.3 (2019-04-16) [x86_64-darwin18]
[2019-09-09 23:20:05] INFO  WEBrick::HTTPServer#start: pid=30871 port=8080
```

## How to customize
You can customize the Makanai project by changing the sample directory. (You can also change the directory name from the sample.)

To see what features are available, see Usage.

# Usage

create a ruby ​​file(ex. app.rb).

``` ruby
require_relative '../lib/main.rb'

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

## constitution
Makanai application has the following constitution.

```
root ┬ app.rb    # main application file
     ├ views     # views files(ex. index.erb)
     ├ models    # models files(ex. post.rb)
     ├ migration # migration files(ex. 00_create_resources.sql)
     └ db        # use Sqlite3 dabase file
```

## routing

``` ruby
require_relative '../lib/main.rb'

# root path
router.get '/' do
  'Hello Makanai!'
end

# enable access to /hoge
router.get '/hoge' do
  'Hello Hoge!'
end

# enable access to /params with get parameter
router.get '/check' do |request|
  request.params['hoge']
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
require_relative '../lib/main.rb'

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
require_relative '../../lib/model.rb'

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
