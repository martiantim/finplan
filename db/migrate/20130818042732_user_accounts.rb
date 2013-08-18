class UserAccounts < ActiveRecord::Migration
  def up
    create_table "accounts", :force => true do |t|
      t.string   "name", :null => false      
      t.integer :plan_id, :null => false
      t.integer :balance
    end
  end

  def down
    drop_table :accounts
  end
end
