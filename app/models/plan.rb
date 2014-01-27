class Plan < ActiveRecord::Base
  belongs_to :user

  has_many :manipulators  
  has_many :plan_users
  has_many :users, :through => :plan_users, :order => "born"
  has_many :accounts

  SUPPORTED_STATES = [
    ["Alabama","AL"],
    ["Alaska","AK"],
    ["Arizona","AZ"],
    ["Arkansas","AR"],
    ["California","CA"],
    ["Colorado","CO"],
    ["Connecticut","CT"],
    ["Delaware","DE"],
    ["District of Columbia","DC"],
    ["Florida","FL"],
    ["Georgia","GA"],
    ["Hawaii","HI"],
    ["Idaho","ID"],
    ["Illinois","IL"],
    ["Indiana","IN"],
    ["Iowa","IA"],
    ["Kansas","KS"],
    ["Kentucky","KY"],
    ["Louisiana","LA"],
    ["Maine","ME"],
    ["Montana","MT"],
    ["Nebraska","NE"],
    ["Nevada","NV"],
    ["New Hampshire","NH"],
    ["New Jersey","NJ"],
    ["New Mexico","NM"],
    ["New York","NY"],
    ["North Carolina","NC"],
    ["North Dakota","ND"],
    ["Ohio","OH"],
    ["Oklahoma","OK"],
    ["Oregon","OR"],
    ["Maryland","MD"],
    ["Massachusetts","MA"],
    ["Michigan","MI"],
    ["Minnesota","MN"],
    ["Mississippi","MS"],
    ["Missouri","MO"],
    ["Pennsylvania","PA"],
    ["Rhode Island","RI"],
    ["South Carolina","SC"],
    ["South Dakota","SD"],
    ["Tennessee","TN"],
    ["Texas","TX"],
    ["Utah","UT"],
    ["Vermont","VT"],
    ["Virginia","VA"],
    ["Washington","WA"],
    ["West Virginia","WV"],
    ["Wisconsin","WI"],
    ["Wyoming","WY"]
  ]
  
  def used_template?(id)
    manipulators.detect { |m| m.manipulator_template_id == id }
  end
  
  def unused_factors
    ManipulatorTemplate.all.find_all { |t| !used_template?(t.id) && t.kind == 'factor' }
  end
  
  def goals
    manipulators.find_all { |m| m.manipulator_template.kind == 'goal' }
  end
  
  def unused_goals
    ManipulatorTemplate.all.find_all { |t| !used_template?(t.id) && t.kind == 'goal' }
  end

  def incomes
    manipulators.find_all { |m| m.manipulator_template.kind == 'income' }
  end
  
  def expenses
    manipulators.find_all { |m| m.manipulator_template.kind == 'factor' }
  end
  
  def unused_expenses
    ManipulatorTemplate.all.find_all { |t| !used_template?(t.id) && t.kind == 'factor' }
  end

  def manipulator_for_plan_user(template_name, puser)
    manipulators.detect do |m| 
      m.manipulator_template.name == template_name && m.plan_user && m.plan_user.id == puser.id
    end
  end
  
  def manipulator_for_plan_user_or_create(template_name, puser)
    m = manipulator_for_plan_user(template_name, puser)
    if !m
      template = ManipulatorTemplate.find_by_name(template_name)
      m = manipulators.create!(:name => template.name, :manipulator_template => template, :plan_user => puser, :params => {}.to_json)
    end
    m
  end
  
  def priority_sorted_manipulators
    manipulators.sort_by do |m|
      m.manipulator_template.priority
    end
  end
  
end