class ManipulatorTemplatesController < ApplicationController
  
  def new
    @template = ManipulatorTemplate.new(:user_id => @current_user.id)
  end
  
  def create
    @template = ManipulatorTemplate.new(params[:manipulator_template])    
    
    if @template.save
      redirect_to('/manipulator_templates')
    else
      render :action => "new"
    end
  end
  
  def show
    @template = ManipulatorTemplate.find(params[:id])
  end
  
  def index
    @templates = ManipulatorTemplate.sorted_by_priority.all
  end
  
  def update
    @template = ManipulatorTemplate.find(params[:id])
    
    @template.update_attributes(params[:manipulator_template])
    if @template.save    
      redirect_to '/manipulator_templates'
    else
      render :action => 'show'
    end
  end
  
end
