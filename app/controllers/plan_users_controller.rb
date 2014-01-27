class PlanUsersController < ApplicationController

  def index
    plan = Plan.find(params[:plan_id])

    render :partial => 'list', :object => plan.plan_users, :locals => {:active => 'none'}
  end

  def create
    plan = Plan.find(params[:plan_id])
    pu = plan.plan_users.create!(params.require(:plan_user).permit!)

    render :json => {:id => pu.id}
  end

  def update
    pu = PlanUser.find(params[:id])
    pu.update_attributes(params.require(:plan_user).permit!)

    if params[:salary_manipulator_id]
      salary = Manipulator.find(params[:salary_manipulator_id])
      salary.params = params[:variables].to_json
      salary.save!
    end

    render :json => {:id => pu.id}
  end

  def show
    @plan = Plan.find(params[:plan_id])
    if params[:id] == 'all'
      render :partial => 'index'
      return
    elsif params[:id] == 'spouse'
      @plan_user = PlanUser.new(:name => "Spouse", :born => Date.parse("1988-01-01"))
    elsif params[:id] == 'child'
      @plan_user = PlanUser.new(:name => "Child", :born => Date.parse("2010-01-01"))
    elsif params[:id] == 'future_child'
      @plan_user = PlanUser.new(:name => "Future Child", :born => Date.parse("2015-01-01", :gender => 'U'))
    else
      @plan_user = PlanUser.find(params[:id])
    end
    

    
    render :layout => false
  end
  
  def destroy
    pu = PlanUser.find(params[:id])
    pu.destroy
    
    render :text => 'ok'
  end
  
end
