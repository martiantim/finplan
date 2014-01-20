class MoveUserStuffToPlanUsers < ActiveRecord::Migration
  def up
    add_column :plan_users, :name, :string, :null => false
    add_column :plan_users, :born, :date
    add_column :plan_users, :profession_id, :integer
    add_column :plan_users, :gender, :string, :limit => 1, :null => false

    PlanUser.all.each do |pu|
      u = User.find(pu.user_id)
      pu.name = u.name
      pu.born = u.born
      pu.profession_id = u.profession_id
      pu.gender = u.gender

      pu.save!
    end
  end

  def down
  end
end
