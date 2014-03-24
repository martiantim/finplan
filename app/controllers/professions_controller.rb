class ProfessionsController < ApplicationController

  def index
    render :json => Profession.all.collect do |p|
      {
        :id => p.id,
        :name => p.name
      }
    end
  end

end