class AddSpecies < ActiveRecord::Migration
  def up
    add_column :users, :species, :string, :null => false, :default => "human"
  end

  def down
    remove_column :users, :species
  end
end
