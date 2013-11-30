class Manipulator < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  belongs_to :manipulator_template
  belongs_to :start_user, :class_name => 'User'
  
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
      :do_formula => self.manipulator_template.do_javascript,
      :formula => self.manipulator_template.javascript,
      :user_id => self.user_id
    }
  end
  
  def start_user_age
    if !start || !start_user
      0
    else
      self.start.year - self.start_user.born.year
    end
  end
  
  def param_value(key)
    parms = self.params
    parms = "{}" if parms.blank? || parms == "null"

    JSON.parse(parms)[key] || manipulator_template.default_param_value(key)
  end
  
  def is_goal?
    manipulator_template.kind == 'goal'
  end
    
end