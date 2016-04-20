# RubyRooted

RubyRooted is a lightweight ORM written in Ruby, based off of the ActiveRecord library used in Rails.

### Setup

1. RubyRooted is designed to interact with an SQLite3 database.  Before including
RubyRooted into your Rails repo, make sure that your project is using an SQLite3 database.
2. Clone this repo and include the lib folder in your rails db folder.  
3. Update DB_FILE and SQL_FILE in db_connection.rb with appropriate sqlite3 database file
(i.e. development.sqlite3)
4. Every time you create a new model, inherit it from RootObject and call finalize! before closing the model
5. Query away

### Given Methods
- `::table_name`: return name of table in db
- `::table_name=`: allows you to manually set table name in db
- `::columns`: return array with column names in db
- `::all`: returns an array of all the records in the DB
- `::find`: looks up a single record by primary key
- `::where`: takes a params hash and returns an array where all objects match the params
- `::finalize!`: sets up setters and getters for all columns in the db
- `#attributes`: return hash with keys as db column names and values as column values
- `#attribute_values`: returns array with attribute values
- `#insert`: inserts a new row into the table to represent the RootObject.
- `#update`: updates the row with the id of this RootObject
- `#save`: convenience method that either calls insert/update depending on whether or not the RootObject already exists in the table.

### Associations
Call these at the top of your model to set up associations

- `::belongs_to(name, options)`
- `::has_many(name, options)`
- `::has_one_through(name, through_name, source_name)`
