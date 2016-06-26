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
