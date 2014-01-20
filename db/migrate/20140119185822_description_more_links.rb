class DescriptionMoreLinks < ActiveRecord::Migration
  def change
    add_column :manipulator_templates, :description_more_link, :string
    add_column :variable_properties, :description_more_link, :string
  end
end
