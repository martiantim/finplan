class TemplateAdditions < ActiveRecord::Migration
  def up
    add_column "manipulator_templates", 'javascript', :string, :limit => 1024*100
  end

  def down
    remove_column "manipulator_templates", 'javascript'
  end
end
