class ManipulatorTemplate < ActiveRecord::Base
  belongs_to :user
  
  validate :validate_coffeescript
  before_save :generate_javascript
  
  def validate_coffeescript
    begin
      CoffeeScript.compile(self.formula)
    rescue ExecJS::RuntimeError => e
      errors.add(:formula, "Invalid Coffeescript: #{e.to_s}")
    end
  end
  
  def generate_javascript
    self.javascript = CoffeeScript.compile(self.formula)
  end
  
  def variables
    vars = []
    self.formula.scan(/params\['(\S+)'\]/) do |match|
      vars << {:name => $1, :type => :param}
    end
    vars
  end
  
  def params
    variables.find_all { |v| v[:type] == :param }.collect { |v| v[:name] }
  end
  
end