class ManipulatorsController < ApplicationController
  
  def new
    @template = ManipulatorTemplate.find(params[:manipulator_template_id])
    plan = Plan.find(params[:plan_id])
    @manipulator = Manipulator.new(:manipulator_template => @template, :plan => plan, :name => @template.name)
    
    render :layout => false
  end
  
  def create
    @m = Manipulator.new(params[:manipulator])
    @m.params = params[:variables].to_json

    if @m.save
      redirect_to('/plans/1')
    else
      render :action => "new"
    end
  end
  
  def show
    @manipulator = Manipulator.find(params[:id])
    @template = @manipulator.manipulator_template
    
    render :layout => false
  end
  
  def update
    @manipulator = Manipulator.find(params[:id])
        
    @manipulator.update_attributes(params[:manipulator])
    @manipulator.params = params[:variables].to_json
    @manipulator.save!
    
    redirect_to('/plans/1')
  end
  
  def destroy
    @manipulator = Manipulator.find(params[:id])        
    @manipulator.destroy    
    
    render :text => 'ok'
  end
  
end
