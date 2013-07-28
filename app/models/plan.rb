class Plan < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name
  
  has_many :manipulators  
  
  def used_template?(id)
    manipulators.detect { |m| m.manipulator_template_id == id }
  end
  
  def unused_factors
    ManipulatorTemplate.all.find_all { |t| !used_template?(t.id) && t.kind == 'factor' }
  end
  
  def goals
    manipulators.find_all { |m| m.manipulator_template.kind == 'goal' }
  end
  
  def factors
    manipulators.find_all { |m| m.manipulator_template.kind == 'factor' }
  end
  
end