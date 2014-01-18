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
    acct = Account.create!(params.require(:account).permit!)
    
    render :json => {:id => acct.id}
  end
  
  def update
    a = Account.find(params[:id])
    a.update_attributes(params.require(:account).permit!)

    render :json => {:id => a.id}
  end
  
end
