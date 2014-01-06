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
#
#TODO:
#
# -require minimum withdraws
# -keep track of basis and only pay taxes on gains
# -pay proper taxes on retirement withdraws
# -move to another state when retire
# -retire should have lifestyle instead of guess at expenses
# -show number of years achieve for long-running
# -paid by hour
# -existing debts
# -still in school
# -goal: more school
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
