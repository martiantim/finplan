class RateTables < ActiveRecord::Migration
  def up
    create_table "tax_rate_schedules", :force => true do |t|
      t.string "name", :null => false
    end
    create_table "tax_brackets", :force => true do |t|
      t.integer "tax_rate_schedule_id", :null => false
      t.integer "range_top", :null => false
      t.decimal "rate", :null => false, precision: 5, scale: 2
    end
  end

  def down
    drop_table :tax_brackets
    drop_table :tax_rate_schedules
  end
end
