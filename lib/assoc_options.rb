class AssocOptions
  attr_accessor :class_name, :foreign_key, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end
