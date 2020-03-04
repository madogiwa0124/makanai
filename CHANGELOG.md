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
