class AddUserGender < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string, :limit => 1

    User.first.update_attributes!(:gender => 'M')
  end
end
