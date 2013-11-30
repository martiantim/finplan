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
      render :json => {:id => @m.id}
    else
      render :action => "new"
    end
  end
  
  def show
    if params[:id] =~ /template:(\d+)/
      @template = ManipulatorTemplate.find($1)
      plan = Plan.find(params[:plan_id])
      @manipulator = Manipulator.new(:manipulator_template => @template, :plan => plan, :name => @template.name)
    else
      @manipulator = Manipulator.find(params[:id])
      @template = @manipulator.manipulator_template
    end
    
    render :layout => false
  end
  

  def destroy
    @manipulator = Manipulator.find(params[:id])        
    @manipulator.destroy    
    
    render :text => 'ok'
  end

  def goals
    plan = Plan.find(params[:plan_id])
    
    render :partial => 'goals', :object => plan.goals, :locals => {:unused_goals => plan.unused_goals}
  end
  
end
