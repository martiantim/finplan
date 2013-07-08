class CreateBasicClasses < ActiveRecord::Migration
  def up
    create_table "users", :force => true do |t|
      t.string "name",     :null => false
    
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "plans", :force => true do |t|
      t.string "name",     :null => false
      t.integer "user_id"
    
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    u = User.create!(:name => "Tim")    
    u.plans.create!(:name => "Life")
  end

  def down
    drop_table "users"
    drop_table "plans"
  end
end
