class BornYear < ActiveRecord::Migration
  def up
    add_column :users, :born, :date
    User.find(1).update_attribute(:born, Date.parse("01/01/1978"))
  end

  def down
    remove_column :users, :born
  end
end
