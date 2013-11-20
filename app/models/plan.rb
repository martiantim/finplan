class Plan < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name
  
  has_many :manipulators  
  has_many :plan_users
  has_many :accounts
  
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

  def manipulator_for_user(template_name, suser)
    manipulators.detect do |m| 
      m.manipulator_template.name == template_name && m.user && m.user.id == suser.id
    end
  end
  
  def manipulator_for_user_or_create(template_name, suser)
    m = manipulator_for_user(template_name, suser)
    if !m
      template = ManipulatorTemplate.find_by_name(template_name)
      m = manipulators.create!(:name => template.name, :manipulator_template => template, :user => suser, :params => {}.to_json)
    end
    m
  end
  
  def priority_sorted_manipulators
    manipulators.sort_by do |m|
      if m.manipulator_template.kind == 'income'
        -1
      elsif m.manipulator_template.kind == 'goal'
        1
      else
        0
      end
    end
  end
  
end