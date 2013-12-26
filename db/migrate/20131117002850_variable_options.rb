class VariableOptions < ActiveRecord::Migration
  def up
    add_column :variable_properties, :options, :string
  end

  def down
    remove_column :variable_properties, :options
  end
end
