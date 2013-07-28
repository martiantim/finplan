class AddCans < ActiveRecord::Migration
  def up
    add_column :manipulator_templates, :can_formula, :string, :limit => 4096
    add_column :manipulator_templates, :can_javascript, :string, :limit => 10*4096
  end

  def down
  end
end
