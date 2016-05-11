require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
  )

  def model_class
    # TODO: What is this for?
    @class_name.constantize
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

    @class_name ||= name.to_s.classify
    @foreign_key ||= :"#{name}_id"
    @primary_key ||= :id

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = :"#{self_class_name.underscore}_id"
    @class_name = name.to_s.classify
    @primary_key = :id

    options.each do |key, val|
      self.send(:"#{key}=", val)
    end
  end
end

module Associatable
  # Phase IIIb
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
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
