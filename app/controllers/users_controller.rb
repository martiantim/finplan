class UsersController < ApplicationController
  
  def create
    u = User.create(params[:user])
    plan = Plan.find(params[:plan_id])
    plan.plan_users.create!(:user => u)
    
    redirect_to('/plans/1')
  end
  
end
