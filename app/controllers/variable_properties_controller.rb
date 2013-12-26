class VariablePropertiesController < ApplicationController
  
  def show
    @vprop = VariableProperty.find(params[:id])
  end
  
  def index    
    template = ManipulatorTemplate.find(params[:template_id])
    @vars = template.variable_properties
  end
  
  def update
    vprop = VariableProperty.find(params[:id])
    
    vprop.update_attributes(params[:variable_property])
    if vprop.save    
      redirect_to "/variable_properties?template_id=#{vprop.manipulator_template_id}"
    else
      render :action => 'show'
    end
  end
  
end
