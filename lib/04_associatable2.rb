require_relative '03_associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]

    define_method(name) do
    source_options =
      through_options.model_class.assoc_options[source_name]

    source_options.model_class.where(
      source_options.primary_key => self.id).first
    end
  end
end
