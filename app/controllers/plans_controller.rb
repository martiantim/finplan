#DONE
# -people
# -professions
# -faces
# -ability to remove people
# -ajaxforms
# -people in js better
# -put coffee files in directories
# -existing savings
# 
#
#TODO:
# -show proper family members for years
#
# -show people with object for their profession
# -investments
# -types for template params
# -rework of UI
# -existing debts
# 
# -more coffee in classes
# -still in school
# -tables for taxes etc
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
