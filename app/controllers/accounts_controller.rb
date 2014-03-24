class AccountsController < ApplicationController

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
        render :partial => 'list', :object => plan.accounts
      end
      format.json do
        render :json => plan.accounts.collect(&:safe_json)
      end
    end
  end
  
  def show
    if params[:plan_id]
      @plan = Plan.find(params[:plan_id])
    else
      @plan = @current_user.plans.first
    end

    if params[:id] == 'new_account'
      @account = Account.new(:name => "", :plan_id => params[:plan_id])    
    else
      @account = Account.find(params[:id])
    end

    respond_to do |format|
      format.html do
        render :layout => false
      end
      format.json do
        render :json => @account.safe_json
      end
    end
  end

  def investment_types
    render :json => Account::INVESTMENT_TYPES
  end

  def account_types
    h = {}
    Account::KINDS.each do |a|
      h[a[:name]] = a
    end

    render :json => h
  end
  
  def destroy
    ac = Account.find(params[:id])
    ac.destroy
    
    render :text => 'ok'
  end
  
  def create
    acct = Account.new(params.require(:account).permit!)

    if acct.save
      render :json => {:id => acct.id}
    else
      render :json => model_errors_hash(acct), :status => 500
    end
  end
  
  def update
    a = Account.find(params[:id])

    if a.update_attributes(params.require(:account).permit!)
      render :json => {:id => a.id}
    else
      render :json => model_errors_hash(a), :status => 500
    end
  end
  
end
