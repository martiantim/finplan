class ManipPriorities < ActiveRecord::Migration
  def up
    add_column :manipulator_templates, :priority, :integer, :null => false, :default => 5
  end

  def down
  end
end
