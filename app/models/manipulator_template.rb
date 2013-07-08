class ManipulatorTemplate < ActiveRecord::Base
  belongs_to :user
  
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