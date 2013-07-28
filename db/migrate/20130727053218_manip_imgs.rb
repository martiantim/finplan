class ManipImgs < ActiveRecord::Migration
  def up
    add_column :manipulator_templates, :image_url, :string
  end

  def down
    remove_column :manipulator_templates, :image_url
  end
end
