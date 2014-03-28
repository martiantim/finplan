class Manipulator < ActiveRecord::Base
  belongs_to :plan
  belongs_to :plan_user
  belongs_to :manipulator_template
  belongs_to :start_plan_user, :class_name => 'PlanUser'

  def short_safe_json
    {
      :id => self.id,
      :name => self.name,
      :image_url => self.manipulator_template.image_url
    }
  end

  def safe_json
    {
      :id => self.id,
      :name => self.name,
      :template_name => self.manipulator_template.name,
      :image_url => self.manipulator_template.image_url,
      :start => self.start,
      :end => self.end,
      :params_str => self.params,
      :kind => self.manipulator_template.kind,
      :can_formula => self.manipulator_template.can_javascript,
      :do_formula => self.manipulator_template.do_javascript,
      :formula => self.manipulator_template.javascript,
      :user_id => self.plan_user_id,
      :has_when_date => self.manipulator_template.has_when_date,
      :start_type => self.start_type,
      :start_plan_user_id => self.start_plan_user_id,
      :start_plan_user_age => self.start_plan_user_age,

      :params => self.manipulator_template.params_hash(self)
    }
  end
  
  def start_plan_user_age
    if !start || !start_plan_user
      0
    else
      self.start.year - self.start_plan_user.born.year
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