require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor :class_name, :foreign_key, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end


class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    options.each do |key, val|
      send(:"#{key}=", val)
    end

    self.class_name ||= name.to_s.classify
    self.foreign_key ||= :"#{name}_id"
    self.primary_key ||= :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, klass, options = {})
    self.foreign_key = :"#{klass.underscore}_id"
    self.class_name = name.to_s.classify
    self.primary_key = :id

    options.each { |key, val| self.send(:"#{key}=", val) }
  end
end

module Associatable
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name, options)
    options = assoc_options[name]

    define_method(:"#{name}") do
      model_class = options.model_class
      foreign_key_id = self.send(options.foreign_key)

      result = model_class.where(options.primary_key => foreign_key_id)

      result.empty? ? nil : result.first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, to_s, options)
    define_method(:"#{name.to_s.pluralize.to_sym}") do
      model_class = options.model_class

      result = model_class.where(options.foreign_key => self.id)

      result.empty? ? [] : result
    end
  end

  def assoc_options
    self.assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
