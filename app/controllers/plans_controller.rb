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
#TODO:
#
# -take out retirement money as needed
# -handle bankrupcy well
# -nice descriptions
# -allow expenses to grow with income (people can't control spending, show scenarios)
# -keep track of basis and only pay taxes on gains
# -redo social security in year retire
# -move to another state when retire
# -retire should have lifestyle instead of guess at expenses
# -show number of years achieve for long-running
# -paid by hour
# -existing debts
# -still in school
# -research how much less people actually use in retirement (saw in the dummies financial planning book)
# -remove pets
# -scenario "SS doesn't exit or lowered payout"
# -scenario "Different investment returns"
# -goal: more school
# -goal: investment property
# -goal: vacation home
# -goal: leave inheritance
# -cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
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
      :family_members => @plan.plan_users.collect(&:user).collect(&:safe_json)
    }
  end
  
end
