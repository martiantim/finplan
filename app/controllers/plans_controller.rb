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
  
end
