class UserLogin < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, :null => false, :default => "a"
    add_column :users, :salt, :string
    add_column :users, :password_encrypted, :string, :null => false, :default => "a"
    add_column :users, :auth_token, :string

    tim = User.find(1)
    tim.email = "timmartin@alumni.cmu.edu"
    tim.password = "abcd"
    tim.save!
  end
end
