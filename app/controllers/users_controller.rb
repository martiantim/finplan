class UsersController < ApplicationController
  
  def create
    u = User.create(params[:user])
    plan = Plan.find(params[:plan_id])
    plan.plan_users.create!(:user => u)
    
    render :json => {:id => u.id}
  end
  
  def update
    u = User.find(params[:id])
    u.update_attributes(params[:user])    
    
    if params[:salary_manipulator_id]
      salary = Manipulator.find(params[:salary_manipulator_id])
      salary.params = params[:variables].to_json
      salary.save!
    end

    render :json => {:id => u.id}
  end

  def show
    if params[:id] == 'spouse'
      @user = User.new(:name => "Spouse", :born => Date.parse("1988-01-01"))
    elsif params[:id] == 'child'
      @user = User.new(:name => "Child", :born => Date.parse("2010-01-01"))
    elsif params[:id] == 'future_child'
      @user = User.new(:name => "Future Child", :born => Date.parse("2015-01-01", :gender => 'U'))
    else
      @user = PlanUser.find(params[:id]).user
    end

    @plan = Plan.find(params[:plan_id])

    render :layout => false
  end
  
end
