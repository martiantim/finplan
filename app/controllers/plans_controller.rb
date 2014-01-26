#DONE
# -people
# -professions
# -faces
# -ability to remove people
# -ajaxforms
# -people in js better
# -put coffee files in directories
# -existing savings
# -show proper family members for years
# -types for template params
# -rework of UI
# -investments
# -more coffee in classes
# -tables for taxes etc
# -show people with object for their profession
# -show person age
# -require minimum withdraws
# -pay proper taxes on retirement withdraws
# -allow invest savings account
# -better loans
#
#TODO: expenses: Housing, Car(s), and Healthcare. Rest is individual or spend all
#TODO: how to do scenarios
#TODO: valid ages for goal ages
#TODO: redo social security in year retire
#TODO: show number of years achieve for long-running goals
#TODO: take out retirement money as needed
#TODO: handle bankrupcy well
#TODO: allow expenses to grow with income (people can't control spending, show scenarios)
#TODO: keep track of basis and only pay taxes on gains
#TODO: retire should have lifestyle instead of guess at expenses
#TODO: existing debts
#TODO: still in school
#TODO: complete job pictures
#TODO: research how much less people actually use in retirement (saw in the dummies financial planning book)
#TODO: scenario "SS doesn't exist or lowered payout"
#TODO: scenario "Different investment returns"
#TODO: goal: more school
#TODO: goal: vacation home
#TODO: goal: leave inheritance
#TODO: landing page: http://blog.kissmetrics.com/landing-page-design-infographic/
#2.0
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
  
  def show
    @plan = Plan.find(params[:id])
  end
  
  def reload
    @plan = Plan.find(params[:id])
    render :json => {
      :manipulators => @plan.priority_sorted_manipulators.collect(&:safe_json),
      :accounts => @plan.accounts.collect(&:safe_json),
      :family_members => @plan.plan_users.collect(&:safe_json)
    }
  end
  
end
