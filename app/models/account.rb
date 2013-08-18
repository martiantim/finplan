class Account < ActiveRecord::Base
  belongs_to :plan
  
  KINDS = [
    "Checking",
    "Emergency",
    "HSA",
    "Investment",
    "Roth IRA",
    "401K"
  ]
  
  def safe_json
    {
      :id => self.id,
      :name => self.name,
      :balance => self.balance
    }
  end
  
end
