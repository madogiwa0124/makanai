# CHANGELOG

## :gift: 2019/10/22 `v0.1.0` released.

* :tada: first release

## :gift: 2019/12/28 `v0.1.1` released.

* :sparkles: add Makanai app genarator.  
  Added `makanai init` command for initialize makanai application.  
  https://github.com/Madogiwa0124/makanai/pull/5

* :sparkles: add `Makanai::Model#first`.  
  execute `SELECT * FROM table_name ORDER BY prymary_key asc limit 1` and return record object.  
  https://github.com/Madogiwa0124/makanai/commit/8949796bf7428f5e2d854041b35397ef4d442ee6

## :gift: 2020/02/22 `v0.1.2` released.
* :sparkles: use config object by Makanai::Settings for replaceable app config.  
  Changed the setting so that it is retained by the Class variable, and made it configurable.
  The big advantage is that you can use any web server(ex. puma) except WEBrick.  
  https://github.com/Madogiwa0124/makanai/pull/18/commits/e6ea10e596c685ef77c042fa1e8f0294c85166f2

## :gift: 2020/03/04 `v0.1.3` released.
* :sparkles: Multiple DBMS available.  
  you can use dbms(MySQL :dolphin:, PostgreSQL :elephant:) other then SQLite.  
  https://github.com/Madogiwa0124/makanai/pull/19

## :gift: 2020/04/08 `v0.1.4` released.
* :sparkles: support lastest ruby versions(2.6.6, 2.7.1)
* :sparkles: support for dynamic URL routing.

  ``` ruby
  router.get '/hoge/:id' do
    request.params['id']
  end
  ```

  https://github.com/Madogiwa0124/makanai/commit/e256368fd0a13f1d0d2d6c6af17caef7760e64f0

## :gift: 2020/06/16 `v0.1.5` released.
* :package: dependency update.

## :gift: 2020/08/07 `v0.1.6` released.
* :sparkles: enabled to switch template engine Haml and ERB.  
  https://github.com/Madogiwa0124/makanai/commit/b9f977fe9e974aa1abbf2764a2fdad989e2767ec

* :zap: remove sqlite3 from runtime_dependency.  
  https://github.com/Madogiwa0124/makanai/commit/d63c3b12cf6fc412a8d88806dca9710e210e5fe0

## :gift: 2021/01/05 `v0.1.7` released.
* :package: dependency update.
* :gem: supported ruby `3.0.0`.
  https://github.com/Madogiwa0124/makanai/pull/82

## :gift: 2022/09/17 `v0.1.8` released.
* :package: dependency update.
* :gem: supported rack `3.0.0`.
  https://github.com/madogiwa0124/makanai/pull/162
