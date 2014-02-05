class AddGender < ActiveRecord::Migration
  def up
    add_column :users, :gender, :string, :limit => 1, :null => false, :default => 'U'
    
    User.find_by_name("Tim").update_attribute(:gender, 'M')
    User.find_by_name("April").update_attribute(:gender, 'F')
  end

  def down
  end
end
