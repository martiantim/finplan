class PlanUsersController < ApplicationController
  
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
  
end
