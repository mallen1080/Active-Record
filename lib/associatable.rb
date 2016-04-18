require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] ||
      (name.to_s + "Id").underscore.to_sym

    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] ||
      name.to_s.singularize.camelize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] ||
      (self_class_name + "Id").underscore.to_sym

    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] ||
      name.to_s.singularize.camelize
  end
end

module Associatable

  def belongs_to(name, options = {})
    options_obj = BelongsToOptions.new(name, options)
    @assoc_options ||= {}
    @assoc_options[name] = options_obj

    define_method(name) do
      klass = options_obj.model_class
      primary = options_obj.primary_key
      klass.where(primary => self.id).first
    end
  end

  def has_many(name, options = {})
    self_class_name = self.to_s
    options_obj = HasManyOptions.new(name, self_class_name, options)

    define_method(name) do
      klass = options_obj.model_class
      foreign = options_obj.foreign_key
      klass.where(foreign => self.id)
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
    source_options =
      through_options.model_class.assoc_options[source_name]

    source_options.model_class.where(
      source_options.primary_key => self.id).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class RootObject
  extend Associatable
end
