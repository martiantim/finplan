class ManipulatorStartType < ActiveRecord::Migration
  def up
    add_column :manipulators, :start_type, :string
    add_column :manipulators, :start_user_id, :integer
  end

  def down
    remove_column :manipulators, :start_type
    remove_column :manipulators, :start_user_id
  end
end
