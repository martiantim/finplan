# -people
#
#TODO:
# -existing savings
# -people in js better
# -existing debts
# 
# -more coffee in classes
# -put coffee files in directories
# -professions
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
