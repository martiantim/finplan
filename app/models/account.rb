class Account < ActiveRecord::Base
  belongs_to :plan
  
  KINDS = [    
    {:name => "Checking",   :type => 'current'},
    {:name => "Savings",    :type => 'current'},
    {:name => "Emergency",  :type => 'current'},
    {:name => "Loan",       :type => 'debt'},
    {:name => "HSA",        :type => 'current'},
    {:name => "Investment", :type => 'invest'},
    {:name => "Traditional IRA", :type => 'invest'},
    {:name => "Roth IRA",   :type => 'invest'},
    {:name => "401K",       :type => 'invest'},
  ]
  
  INVESTMENT_TYPES = [
    "Money Market",
    "Bonds",
    "Stock",
    "Target Retirement"
  ]
  
  def kind
    KINDS.detect { |a| a[:name] == self.name }
  end
  
  def can_invest?
    new_record? || kind[:type] == 'invest'
  end
  
  def is_debt?
    new_record? || kind[:type] == 'debt'
  end
  
  def safe_json
    {
      :id => self.id,
      :name => self.name,
      :balance => self.balance,
      :investment_type => self.investment_type,
      :interest_rate => self.interest_rate
    }
  end
  
end
