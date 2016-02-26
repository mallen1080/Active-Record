require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
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
    @class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    if options == {}
      @foreign_key = (name.to_s + "_id").to_sym
      @primary_key = :id
      @class_name = name.to_s.downcase.capitalize
    else
      @foreign_key = options[:foreign_key]
      @primary_key = options[:primary_key]
      @class_name = options[:class_name]
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    if options == {}
      @foreign_key = (self_class_name + "_id").downcase.singularize.to_sym
      @primary_key = :id
      @class_name = name.to_s.downcase.singularize.capitalize
    else
      @foreign_key = options[:foreign_key]
      @primary_key = options[:primary_key]
      @class_name = options[:class_name]
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options_obj = BelongsToOptions.new(name, options)
    define_method(name) do
      klass = options_obj.send(:model_class)
      forein = options_obj.send(:foreign_key)
      primary = options_obj.send(:primary_key)
      klass.where(primary = self.id)
    end
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
