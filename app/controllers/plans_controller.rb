#TODO: "Goal will be achieved in 2058" should be X% of years for recurring goals
#TODO: mark results as out of date when make changes
#TODO: logo outline
#TODO: warning/advice system
#TODO: suggestions when bankruptcy or goal not achieved
#TODO: better handling of accounts in javascript
#TODO: help text for all account types
#TODO: allow specifying IRA savings in accounts page
#TODO: allow adding 2nd/3rd car
#TODO: April worked into their golden years -> links for improvements "_save more_ in IRA accounts"
#TODO: do all logging thru simcontext
#TODO: keep track of basis and only pay taxes on gains
#TODO: remaining state income tax schedules
#TODO: still in school
#TODO: childcare
#TODO: goal: more school [say how much higher/lower will make salary]
#TODO: goal: vacation home
#TODO: taxes on social security
#TODO: goal pay off credit cards
#TODO: if all goals achieved say "try a scenario"
#TODO: graduation hat for when finish college
#TODO: move to another state when retire

#2.0
#TODO: landing page: http://blog.kissmetrics.com/landing-page-design-infographic/
#TODO: 30 year mortgage in market performance
#TODO: bonuses (tied to stock market?)
#TODO: contractor
#TODO: able to control when take social security
#TODO: show green/yellow/red in need/have table
#TODO: cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
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
