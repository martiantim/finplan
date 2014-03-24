class PlanUsersController < ApplicationController

  before_filter :get_user
  before_filter :login_required

  def index
    if params[:plan_id]
      plan = Plan.find(params[:plan_id])
    else
      plan = @current_user.plans.first
    end

    respond_to do |format|
      format.html do
        render :partial => 'list', :object => plan.plan_users, :locals => {:active => 'none'}
      end
      format.json do
        render :json => plan.plan_users.collect(&:safe_json)
      end
    end
  end

  def create
    plan = Plan.find(params[:plan_id])
    pu = plan.plan_users.create!(params.require(:plan_user).permit!)

    salary = plan.manipulators.build(:name => "Salary", :manipulator_template => ManipulatorTemplate.find_by_name("Salary"), :plan_user => pu)
    salary.params = params[:variables].to_json
    salary.save!

    render :json => {:id => pu.id}
  end

  def update
    pu = PlanUser.find(params[:id])
    pu.update_attributes(params.require(:plan_user).permit!)

    if params[:variables]
      if params[:salary_manipulator_id]
        salary = Manipulator.find(params[:salary_manipulator_id])
        salary.params = params[:variables].to_json
        salary.save!
      end
    end

    render :json => {:id => pu.id}
  end

  def show
    if params[:plan_id]
      @plan = Plan.find(params[:plan_id])
    else
      @plan = @current_user.plans.first
    end
    if params[:id] == 'all'
      render :partial => 'index'
      return
    elsif params[:id] == 'spouse'
      @plan_user = PlanUser.new(:name => "Spouse", :born => Date.parse("1988-01-01"), :plan => @plan, :gender => 'U')
    elsif params[:id] == 'child'
      @plan_user = PlanUser.new(:name => "Child", :born => Date.parse("2010-01-01"))
    elsif params[:id] == 'future_child'
      @plan_user = PlanUser.new(:name => "Future Child", :born => Date.parse("2015-01-01", :gender => 'U'))
    else
      @plan_user = PlanUser.find(params[:id])
    end

    respond_to do |format|
      format.html do
        render :layout => false
      end
      format.json do
        render :json => @plan_user.safe_json_with_job(@plan)
      end
    end
  end
  
  def destroy
    pu = PlanUser.find(params[:id])
    pu.plan.manipulators.each { |m| m.destroy if m.plan_user_id == pu.id }
    pu.destroy
    
    render :text => 'ok'
  end
  
end
