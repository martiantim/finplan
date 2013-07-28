class ManipulatorTemplate < ActiveRecord::Base
  belongs_to :user
  
  validate :validate_coffeescript
  before_save :generate_javascript
  
  def validate_coffeescript
    begin
      CoffeeScript.compile(self.formula)
      CoffeeScript.compile(self.can_formula) if !self.can_formula.blank?
    rescue ExecJS::RuntimeError => e
      errors.add(:formula, "Invalid Coffeescript: #{e.to_s}")
    end
  end
  
  def generate_javascript
    self.javascript = CoffeeScript.compile(self.formula, {:bare => true})
    self.can_javascript = CoffeeScript.compile(self.can_formula, {:bare => true}) if !self.can_formula.blank?
  end
  
  def variables
    vars = []
    self.formula.scan(/params\['(\S+)'\]/) do |match|
      vars << {:name => $1, :type => :param} if !vars.detect { |a| a[:name] == $1 }
    end
    vars
  end
  
  def params
    variables.find_all { |v| v[:type] == :param }.collect { |v| v[:name] }
  end
  
end