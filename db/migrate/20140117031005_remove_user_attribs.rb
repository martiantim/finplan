class RemoveUserAttribs < ActiveRecord::Migration
  def up
    remove_column :users, :born
    remove_column :users, :profession_id
    remove_column :users, :gender
    remove_column :users, :species
  end

  def down
  end
end
