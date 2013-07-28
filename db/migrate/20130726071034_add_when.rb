class AddWhen < ActiveRecord::Migration
  def up
    add_column :manipulators, :when, :integer
  end

  def down
    remove_column :manipulators, :when, :integer
  end
end
