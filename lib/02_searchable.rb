require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = []; vals = []
    params.each do |key,val|
      where_line << "#{key} = ? "; vals << val.to_s
    end
    where_line = where_line.join("AND ")
    output = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL

    parse_all(output)
  end
end

class SQLObject
  extend Searchable
end
