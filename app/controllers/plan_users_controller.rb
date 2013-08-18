class PlanUsersController < ApplicationController

  def index
    plan = Plan.find(params[:plan_id])

    render :partial => 'list', :object => plan.plan_users
  end
  
  def show
    if params[:id] == 'spouse'
      @user = User.new(:name => "Spouse", :born => Date.parse("1988-01-01"))
    elsif params[:id] == 'child'
      @user = User.new(:name => "Child", :born => Date.parse("2010-01-01"))      
    elsif params[:id] == 'future_child'
      @user = User.new(:name => "Future Child", :born => Date.parse("2015-01-01"))      
    else
      @user = PlanUser.find(params[:id]).user
    end
    
    @plan = Plan.find(params[:plan_id])
    
    render :layout => false
  end
  
  def destroy
    pu = PlanUser.find(params[:id])
    pu.destroy
    
    render :text => 'ok'
  end
  
end
