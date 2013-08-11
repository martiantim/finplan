#TODO:
# -people
# -professions
# -existing savings
# -existing debts
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
