# RubyRooted

RubyRooted is a lightweight ORM written in Ruby, based off of the ActiveRecord library used in Rails.

### Setup

1. RubyRooted is designed to interact with an SQLite3 database.  Before including
RubyRooted into your Rails repo, make sure that your project is using an SQLite3 database.
2. Clone this repo and include the lib folder in your rails db folder.  
3. Update DB_FILE and SQL_FILE in db_connection.rb with appropriate sqlite3 database file
(i.e. development.sqlite3)
4. Every time you create a new model, inherit it from RootObject
5. Query away

### Given Methods

- ::all: return an array of all the records in the DB
- ::find: look up a single record by primary key
- #insert: insert a new row into the table to represent the SQLObject.
- #update: update the row with the id of this SQLObject
- #save: convenience method that either calls insert/update depending on whether or not the SQLObject already exists in the table.
