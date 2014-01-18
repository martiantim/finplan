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
#TODO: nice descriptions
#TODO: rails 4
#TODO: show net worth
#TODO: show market returns on yearly view
#TODO: take out retirement money as needed
#TODO: handle bankrupcy well
#TODO: allow expenses to grow with income (people can't control spending, show scenarios)
#TODO: keep track of basis and only pay taxes on gains
#TODO: redo social security in year retire
#TODO: move to another state when retire
#TODO: retire should have lifestyle instead of guess at expenses
#TODO: show number of years achieve for long-running goals
#TODO: paid by hour
#TODO: existing debts
#TODO: still in school
#TODO: complete job pictures
#TODO: research how much less people actually use in retirement (saw in the dummies financial planning book)
# -scenario "SS doesn't exit or lowered payout"
# -scenario "Different investment returns"
# -goal: more school
# -goal: investment property
# -goal: vacation home
# -goal: leave inheritance
# -cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
#TODO: landing page: http://blog.kissmetrics.com/landing-page-design-infographic/
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
