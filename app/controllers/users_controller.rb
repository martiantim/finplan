class UsersController < ApplicationController
  
  def create
    u = User.create(params[:user])
    plan = Plan.find(params[:plan_id])
    plan.plan_users.create!(:user => u)
    
    redirect_to('/plans/1')
  end
  
  def update
    u = User.find(params[:id])
    u.update_attributes(params[:user])    
    
    if params[:salary_manipulator_id]
      salary = Manipulator.find(params[:salary_manipulator_id])
      salary.params = params[:variables].to_json
      salary.save!
    end
    
    redirect_to('/plans/1')
  end
  
end
