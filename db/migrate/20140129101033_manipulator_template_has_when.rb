class ManipulatorTemplateHasWhen < ActiveRecord::Migration
  def change
    add_column :manipulator_templates, :has_when_date, :boolean, :null => false, :default => true
  end
end
