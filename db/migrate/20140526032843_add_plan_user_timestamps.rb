class AddPlanUserTimestamps < ActiveRecord::Migration
  def change
    add_column :plan_users, :created_at, :datetime
    add_column :plan_users, :updated_at, :datetime
  end
end
