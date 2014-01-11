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
#
#TODO:
#
# -better loans
# -take out retirement money as needed
# -keep track of basis and only pay taxes on gains
# -redo social security in year retire
# -move to another state when retire
# -retire should have lifestyle instead of guess at expenses
# -show number of years achieve for long-running
# -paid by hour
# -existing debts
# -still in school
# -remove pets
# -goal: more school
# -goal: investment property
# -goal: vacation home
# -goal: leave inheritance
# -cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
#
#

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
