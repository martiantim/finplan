class MoveUserStuffToPlanUsers < ActiveRecord::Migration
  def up
    add_column :plan_users, :name, :string, :null => false
    add_column :plan_users, :born, :date
    add_column :plan_users, :profession_id, :integer
    add_column :plan_users, :gender, :string, :limit => 1, :null => false

    PlanUser.all.each do |pu|
      pu.name = pu.user.name
      pu.born = pu.user.born
      pu.profession_id = pu.user.profession_id
      pu.gender = pu.user.gender

      pu.save!
    end
  end

  def down
  end
end
