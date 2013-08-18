# -people
# -professions
# 
#
#TODO:
# -ability to remove people
# -existing savings
# -people in js better
# -existing debts
# -types for template params
# 
# -more coffee in classes
# -put coffee files in directories
# -still in school
# -investments
# -tables for taxes etc
# -rework of UI
#

class PlansController < ApplicationController
  
  def show
    @plan = Plan.find(params[:id])
  end
  
end
