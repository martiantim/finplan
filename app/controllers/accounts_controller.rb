class AccountsController < ApplicationController
  
  def index
    plan = Plan.find(params[:plan_id])

    render :partial => 'list', :object => plan.accounts
  end
  
  def show
    if params[:id] == 'new_account'
      @account = Account.new(:name => "", :plan_id => params[:plan_id])    
    else
      @account = Account.find(params[:id])
    end
    
    @plan = Plan.find(params[:plan_id])
    
    render :layout => false
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
