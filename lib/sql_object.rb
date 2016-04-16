require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.columns
    return @columns unless @columns.nil?
    output = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    LIMIT
      0
    SQL

    @columns = output.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end

      define_method((column.to_s + "=").to_sym) do |setter|
        attributes[column.to_sym] = setter
      end
    end
  end

  def self.all
    output = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
      #{table_name}
    SQL

    parse_all(output)
  end

  def self.parse_all(results)
    results.map { |row| self.new(row) }
  end

  def self.find(id)
    output = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      id = ?
    SQL
    return nil if output.empty?
    self.new(output.first)
  end

  def initialize(params = {})
    self.class.finalize!
    params.each do |key, val|
      unless self.class.columns.include?(key.to_sym)
        raise "unknown attribute '#{key}'"
      end
      self.send((key.to_s + "=").to_sym, val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |column| @attributes[column] }
  end

  def insert
    attribute_vals = attribute_values.drop(1)
    cols = self.class.columns.drop(1)
    col_names = cols.join(",")
    q_marks = (["?"] * cols.length).join(",")

    DBConnection.execute(<<-SQL, *attribute_vals)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{q_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.drop(1)
    .map { |col| "#{col} = ? " }
    .join(",")

    attribute_vals = attribute_values.drop(1)

    DBConnection.execute(<<-SQL, *attribute_vals)
    UPDATE
      #{self.class.table_name}
    SET
      #{cols}
    WHERE
      id = #{self.id}
    SQL

  end

  def save
    insert if id.nil?
    update unless id.nil?
  end
end
