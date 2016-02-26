require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns unless @columns.nil?
    output = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
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

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    table_name = "#{self}s".downcase
    @table_name ||= table_name
    @table_name
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
    array = []
    results.each { |row| array << self.new(row) }

    array
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
    
  end

  def insert
    cols = self.class.columns
    col_names = cols.join(",")
    q_marks = []
    cols.length.times { q_marks << "?" }
    q_marks = q_marks.join(",")
    DBConnection.execute(<<-SQL)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      #{q_marks}
    SQL
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
