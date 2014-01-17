class PlanUsersController < ApplicationController

  def index
    plan = Plan.find(params[:plan_id])

    render :partial => 'list', :object => plan.plan_users
  end
  
  def show
    if params[:id] == 'spouse'
      @plan_user = PlanUser.new(:name => "Spouse", :born => Date.parse("1988-01-01"))
    elsif params[:id] == 'child'
      @plan_user = PlanUser.new(:name => "Child", :born => Date.parse("2010-01-01"))
    elsif params[:id] == 'future_child'
      @plan_user = PlanUser.new(:name => "Future Child", :born => Date.parse("2015-01-01", :gender => 'U'))
    else
      @plan_user = PlanUser.find(params[:id])
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
