class AddPlanState < ActiveRecord::Migration
  def change
    add_column :plans, :state, :string, :null => false, :default => 'California'
  end
end
