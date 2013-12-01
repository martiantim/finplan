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
#
#
#TODO:
#
# -existing debts
# -still in school
# -cool range changing https://groups.google.com/forum/#!topic/jqplot-users/o8haUFPWhds
# -show people with object for their profession
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
