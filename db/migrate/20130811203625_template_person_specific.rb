class TemplatePersonSpecific < ActiveRecord::Migration
  def up
    add_column :manipulator_templates, :per_person, :boolean, :default => false
  end

  def down
    remove_column :manipulator_templates, :per_person
  end
end
