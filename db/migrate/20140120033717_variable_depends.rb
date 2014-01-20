class VariableDepends < ActiveRecord::Migration
  def change
    add_column :variable_properties, :depends_on, :string
  end
end
