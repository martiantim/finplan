#TODO: logo outline
#TODO: tiny icon

#TODO: tag line "Reach the higher branches"

#TODO: 30 year mortgage in market performance

#TODO: expenses: Housing, Car(s), and Healthcare. Rest is individual or spend all

#TODO: suggestions when bankruptcy or goal not achieved
#TODO: take out money from more accounts before bankruptcy

#TODO: handle already own home
#TODO: warning/advice system

#TODO: BUG; accounts not being updates (set rate to 9% and reran and using old)
#TODO: better handling of accounts
#TODO: do all logging thru simcontext
#TODO: bonuses (tied to stock market?)
#TODO: keep track of basis and only pay taxes on gains
#TODO: remaining state income tax schedules
#TODO: still in school
#TODO: complete job pictures
#TODO: research how much less people actually use in retirement (saw in the dummies financial planning book)
#TODO: taxes rise to european levels
#TODO: childcare
#TODO: fix extra baby scenario
#TODO: goal: more school
#TODO: goal: vacation home
#TODO: landing page: http://blog.kissmetrics.com/landing-page-design-infographic/
#TODO: taxes on social security
#TODO: goal pay off credit cards
#2.0
#TODO: contractor
#TODO: able to control when take social security
#TODO: show green/yellow/red in need/have table
#TODO: cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
#TODO: move to another state when retire
#TODO: goal: investment property
#
#
# Target:
#   -living in USA
#   -age range 18-65
#   -single or married
#   -in school or working
#   -income range 30k-300k approx
#
# Usage scenarios:
#   -can I retire?
#   -can I buy a house and retire
#   -how will going back to school help me financially
#   -can I take time off to spend with kids
#   -what if SS goes away?

class PlansController < ApplicationController

  before_filter :get_user
  before_filter :login_required


  
  def show
    @plan = Plan.find(params[:id])
  end
  
  def reload
    @plan = Plan.find(params[:id])
    render :json => {
      :state => @plan.state,
      :manipulators => @plan.priority_sorted_manipulators.collect(&:safe_json),
      :accounts => @plan.accounts.collect(&:safe_json),
      :family_members => @plan.plan_users.collect(&:safe_json)
    }
  end

  def update
    plan = Plan.find(params[:id])
    plan.update_attributes(params.require(:plan).permit!)

    render :json => {:id => plan.id, :controller => 'plans'}
  end
  
end
