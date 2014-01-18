class BaseManipulatorController < ApplicationController
  def update
    @manipulator = Manipulator.find(params[:id])

    @manipulator.update_attributes(params.require(:manipulator).permit!)
    @manipulator.params = params[:variables].to_json
    @manipulator.save!

    render :json => {:id => @manipulator.id}
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
    @plan = @manipulator.plan

    render :layout => false
  end

end