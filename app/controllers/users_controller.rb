class UsersController < ApplicationController

  before_filter :get_user

  def index
    @plan = Plan.find(params[:plan_id])

    render :partial => '/plan_users/list', :object => @plan.plan_users, :locals => {}
  end

  def login
    if params[:user][:email].blank? || params[:password].blank?
      redirect_to :controller => 'welcome', :action => 'index', :email => params[:user][:email], :error => "Enter Username and Password"
      return
    end
    user = User.find_by_email(params[:user][:email])
    if !user
      redirect_to :controller => 'welcome', :action => 'index', :email => params[:user][:email], :error => "No user with that email"
      return
    end
    if user
      user = nil if !user.password_match?(params[:password])
    end
    if !user
      redirect_to :controller => 'welcome', :action => 'index', :email => params[:user][:email], :error => "Username or Password incorrect"
    else
      remember_login(user)
      redirect_to :controller => 'plans', :action => 'show', :id => user.plans.first.id
    end
  end

  def logout
    cookies[:auth_token] = nil
    @current_user.update_attributes!(:auth_token => nil)

    redirect_to :controller => 'welcome', :action => "index"
  end

  def signup
    if request.post?
      @user = User.new(params.require(:user).permit!)
      @user.password = params[:password]
      if @user.save
        remember_login(@user)

        setup_user(@user)

        redirect_to :controller => 'plans', :action => 'show', :id => @user.plans.first.id
      else
        #show page with errors
      end
    else
      @user = User.new
      #just show page
    end
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

  private

  def remember_login(user)
    user.set_auth_token
    user.save!
    cookies[:auth_token] = user.auth_token # cookie will live till the browser is closed
    cookies[:user_login] = { :value => user.email, :expires => 365.days.from_now }
  end

  def setup_user(user)
    #create default plan
    plan = user.plans.create!(:name => "Life", :state => "California")
    pu = plan.plan_users.create!(:name => user.name, :gender => user.gender, :born => Date.parse("1/1/1990"))

    Account::KINDS.find_all { |acct| !acct[:removable] }.each do |acct|
      plan.accounts.create!(:name => acct[:name], :balance => 0)
    end
    plan.accounts.create!(:name => "401K", :balance => 0, :investment_type => "Target Retirement")

    ['FICA Taxes', 'Social Security Income', 'Salary', 'Housing', 'Car', 'Healthcare', 'Living Expenses'].each do |name|
      m = plan.manipulator_for_plan_user_or_create(name, pu)
      m.save!
    end

    ['Retirement Plan Withdraws', 'Federal Income Tax', 'State Tax'].each do |name|
      m = plan.manipulator_for_plan_user_or_create(name, nil)
      m.save!
    end

    m = plan.manipulator_for_plan_user_or_create('Retire', nil)
    m.params = {:retirement_lifestyle => "about the same"}.to_json
    m.start = pu.born + (65*366)
    m.end = pu.born + (65*366)
    m.start_type = 'age'
    m.start_plan_user = pu
    m.save!

  end
  
end
