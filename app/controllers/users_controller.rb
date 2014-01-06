class UsersController < ApplicationController
  
  def create
    u = User.create(params[:user])
    plan = Plan.find(params[:plan_id])
    plan.plan_users.create!(:user => u)
    
    render :json => {:id => u.id}
  end

  def index
    @plan = Plan.find(params[:plan_id])

    render :partial => '/plan_users/list', :object => @plan.plan_users, :locals => {}
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
    elsif params[:id] == 'pet'
      @user = User.new(:name => "Pet", :born => Date.parse("2013-01-01"), :gender => 'P', :species => 'cat')
    else
      @user = User.find(params[:id])
    end

    @plan = Plan.find(params[:plan_id])

    render :layout => false
  end

  def destroy
    plan = Plan.find(params[:plan_id])
    pu = plan.plan_users.detect { |pu| pu.user_id == params[:id].to_i }
    raise StandardError, "Cannot delete plan owner" if plan.user_id == pu.user_id
    pu.user.destroy
    pu.destroy

    render :text => 'ok'
  end
  
end
