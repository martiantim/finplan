class ManipulatorPerson < ActiveRecord::Migration
  def up
    add_column :manipulators, :user_id, :integer
  end

  def down
    remove_column :manipulators, :user_id
  end
end
