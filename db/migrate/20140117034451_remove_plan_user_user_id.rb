class RemovePlanUserUserId < ActiveRecord::Migration
  def up
    remove_column :plan_users, :user_id
  end

  def down
  end
end
