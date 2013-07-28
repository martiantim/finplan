class Manipulator < ActiveRecord::Base
  belongs_to :plan
  belongs_to :manipulator_template
  
  def safe_json
    {
      :id => self.id,
      :name => self.name,
      :template_name => self.manipulator_template.name,
      :start => self.start,
      :end => self.end,
      :params => self.params,
      :kind => self.manipulator_template.kind,
      :can_formula => self.manipulator_template.can_javascript,
      :formula => self.manipulator_template.javascript
    }
  end
  
  def param_value(key)
    JSON.parse(self.params)[key]
  end
  
  def is_goal?
    manipulator_template.kind == 'goal'
  end
  
end