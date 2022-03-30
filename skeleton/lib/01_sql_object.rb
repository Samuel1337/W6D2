require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns 
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
    @columns.first.map! { |val| val.to_sym }
  end

  def self.finalize!
    
    self.columns.each do |col|
      
      define_method(col) do
        self.attributes[col]
      end

      define_method(col.to_s+'=') do |val|
        self.attributes[col] = val
      end
    end

  end

  def self.table_name=(table_name)
    @table_name ||= table_name
  end

  def self.table_name
    @table_name || "#{self}".tableize
  end

  def self.all
    parse_all DBConnection.execute(<<-SQL)
      SELECT * FROM #{self.table_name}
      SQL
  end

  def self.parse_all(results)
    results.map do |row|
      self.new(row)
    end
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, value| # name: "marie"
      if !self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
