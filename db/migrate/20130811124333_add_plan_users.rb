class AddPlanUsers < ActiveRecord::Migration
  def up
    create_table "plan_users", :force => true do |t|
      t.integer :user_id, :null => false
      t.integer :plan_id, :null => false
      t.string :relation_name
    end
    
    #april = User.create!(:name => 'April', :born => Date.parse("1976-01-01"))
    #Plan.find(1).plan_users.create!(:user => User.first)
    #Plan.find(1).plan_users.create!(:user => april)
  end

  def down
    drop_table :plan_users
  end
end
