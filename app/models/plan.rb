class Plan < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name
  
  has_many :manipulators
  
  def used_template?(id)
    manipulators.detect { |m| m.manipulator_template_id == id }
  end
  
  def unused_templates
    ManipulatorTemplate.all.find_all { |t| !used_template?(t.id) }
  end
  
end