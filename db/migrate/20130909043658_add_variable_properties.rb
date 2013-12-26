class AddVariableProperties < ActiveRecord::Migration
  def up
    create_table :variable_properties, :force => true do |t|
      t.integer :manipulator_template_id, :null => false
      t.string "name", :null => false
      t.string "var_type", :null => false
      t.string "default", :null => false, :default => ""
    end
  end

  def down
    drop_table :variable_properties
  end
end
