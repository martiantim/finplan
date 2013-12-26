class CanDoBreakout < ActiveRecord::Migration
  def up
    add_column :manipulator_templates, :do_formula, :text, :limit => 4096
    add_column :manipulator_templates, :do_javascript, :text, :limit => 10*4096
  end

  def down
  end
end
