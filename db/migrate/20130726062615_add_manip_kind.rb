class AddManipKind < ActiveRecord::Migration
  def up
    add_column :manipulator_templates, :kind, :string, :null => false, :default => "factor"    
  end

  def down
    remove_column :manipulator_templates, :kind, :string
  end
end
