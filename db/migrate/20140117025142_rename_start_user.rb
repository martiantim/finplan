class RenameStartUser < ActiveRecord::Migration
  def up
    rename_column :manipulators, :start_user_id, :start_plan_user_id

    Manipulator.all.each do |m|
      m.start_plan_user_id = 20 if m.plan_user_id == 1
      m.save!
    end

  end

  def down
  end
end
