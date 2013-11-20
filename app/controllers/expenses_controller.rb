class ExpensesController < ApplicationController
  
  def new
    @template = ManipulatorTemplate.find(params[:manipulator_template_id])
    plan = Plan.find(params[:plan_id])
    @manipulator = Manipulator.new(:manipulator_template => @template, :plan => plan, :name => @template.name)
    
    render :layout => false
  end

  def index
    @plan = Plan.find(params[:plan_id])

    render :partial => 'list', :object => @plan.expenses, :locals => {:unused_list => @plan.unused_expenses}
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
  
  def update
    @manipulator = Manipulator.find(params[:id])
    
    if params[:when_type] == 'asap'
      params[:manipulator][:start] = nil 
      params[:manipulator][:end] = nil 
    else
      params[:manipulator][:start] = @current_user.born + (params[:when].to_i*366)
      params[:manipulator][:end] = params[:manipulator][:start]
    end
    
    @manipulator.update_attributes(params[:manipulator])
    @manipulator.params = params[:variables].to_json
    @manipulator.save!

    render :json => {:id => @manipulator.id}
  end
  
  def destroy
    @manipulator = Manipulator.find(params[:id])        
    @manipulator.destroy    
    
    render :text => 'ok'
  end
  
end
