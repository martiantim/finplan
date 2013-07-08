class AddManipulators < ActiveRecord::Migration
  def up
    create_table "manipulator_templates", :force => true do |t|
      t.string "name",     :null => false
      t.integer "user_id", :null => false
      
      t.string "formula", :limit => 4096, :null => false      
      
      t.datetime "created_at"
      t.datetime "updated_at"
    end
      
    create_table "manipulators", :force => true do |t|
      t.string "name",     :null => false
      t.date "start"
      t.date "end"
      
      t.integer "manipulator_template_id", :null => false
      t.integer "plan_id"
      t.string "params", :limit => 4096, :null => false      
      
      
      t.datetime "created_at"
      t.datetime "updated_at"
    end    
        
  end

  def down
    drop_table :manipulator_templates
    drop_table :manipulators
  end
end
