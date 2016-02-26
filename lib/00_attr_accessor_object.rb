class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |instance_name|
      define_method(instance_name) do
        instance_variable_get("@#{instance_name}")
      end
  end
    names.each do |instance_name|
      define_method((instance_name.to_s + "=").to_sym) do |setter|
        instance_variable_set("@#{instance_name}", setter)
      end
    end
  end
end
