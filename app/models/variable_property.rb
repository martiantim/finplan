class VariableProperty < ActiveRecord::Base
  belongs_to :manipulator_template
  
  VAR_TYPES = ['string','money', 'percentage', 'number', 'select']

end