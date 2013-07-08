class Manipulator < ActiveRecord::Base
  belongs_to :plan
  belongs_to :manipulator_template
  
  def safe_json
    {
      :name => self.name,
      :start => self.start,
      :end => self.end,
      :params => self.params,
      :formula => self.manipulator_template.formula
    }
  end
  
  def param_value(key)
    JSON.parse(self.params)[key]
  end
  
end