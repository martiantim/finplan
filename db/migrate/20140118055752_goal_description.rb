class GoalDescription < ActiveRecord::Migration
  def change
    add_column :manipulator_templates, :description, :text
  end
end
