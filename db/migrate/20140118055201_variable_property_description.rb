class VariablePropertyDescription < ActiveRecord::Migration
  def change
    add_column :variable_properties, :description, :text
  end
end
