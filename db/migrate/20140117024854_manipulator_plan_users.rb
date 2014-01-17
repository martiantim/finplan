class ManipulatorPlanUsers < ActiveRecord::Migration
  def up
    rename_column :manipulators, :user_id, :plan_user_id

    Manipulator.all.each do |m|
      m.plan_user_id = 20 if m.plan_user_id == 1
      m.plan_user_id = 21 if m.plan_user_id == 2
      m.save!
    end
  end

  def down
  end
end
