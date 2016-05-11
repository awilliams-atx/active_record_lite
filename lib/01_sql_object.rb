require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    # TODO: Only santize (question-mark, hash interpolation) user-input. Table name does not need to be sanitized.
    @columns ||=
      DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
        0
      SQL
  end

  def self.finalize!
    columns.each do |column|
      define_method(:"#{column}") do
        attributes[column]
      end

      define_method(:"#{column}=") do |val|
        attributes[column] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= to_s.tableize
  end

  def self.all
    results =
      DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
      SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| new(result) }
  end

  def self.find(id)
    results =
      DBConnection.execute(<<-SQL, id: id)
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          id = :id
      SQL

    results.empty? ? nil : new(results.first)
  end

  def initialize(params = {})

    # TODO: Setter/Getter methods exist for this instance. The attr_names coming in from, e.g., Cat.new(name: "Fred", age: 12), are symbols. Send the symbol to self in order to call the setter/getter method.

    params.each do |attr_name, val|
      column = attr_name.to_sym
      raise "unknown attribute '#{attr_name}'" unless column_exists?(column)
      self.send("#{column}=", val)
    end
  end

  def attributes
    # TODO: Some instance variables are not actually columns, so Active Record sets them up in an @attributes hash. E.g. @password in auth.
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def insert
    columns = self.class.columns[1..-1]
    col_names = "(#{columns.join(', ')})"
    question_marks = "(#{(["?"] * columns.count).join(", ")})"
    query = <<-SQL
      INSERT INTO
        #{self.class.table_name} #{col_names}
      VALUES
        #{question_marks}
    SQL

    DBConnection.execute(query, attribute_values)

    self.send(:id=, DBConnection.last_insert_row_id)
  end

  def update
    columns = self.class.columns[1..-1]
    set_line = columns
                 .map{ |col| "#{col} = ?" }
                 .join(", ")

    query = <<-SQL
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL

    DBConnection.execute(query, attribute_values[1..-1], attributes[:id])
  end

  def save
    attributes[:id].nil? ? insert : update
  end

  private

  def column_exists?(column)
    self.class.columns.include?(column)
  end
end
