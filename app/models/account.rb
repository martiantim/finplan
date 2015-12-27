class Account < ActiveRecord::Base
  belongs_to :plan
  
  KINDS = [    
    {:name => "Checking",   :type => 'current', :removable => false, :description => "Bank account where you keep your money for everyday expenses.", :description_more_link => "http://www.investopedia.com/terms/c/checkingaccount.asp"},
    {:name => "Emergency",  :type => 'current', :removable => false, :description => "An account that holds money for use in an emergency. Emergencies include losing your job, an unexpected large bill, etc. This may be a savings account at your bank.", :description_more_link => "http://www.investopedia.com/terms/e/emergency_fund.asp"},
    {:name => "Savings",    :type => 'invest',  :removable => false, :description => "Savings account at a bank or a taxable account at a brokerage. This is money you are saving up for your goals.", :description_more_link => "http://www.investopedia.com/terms/s/savingsaccount.asp"},
    {:name => "Credit Cards",:type => 'debt',   :removable => false, :description => "Plastic. You can add up all your credit cards here or add them individually.", :description_more_link => "http://www.investopedia.com/terms/c/creditcard.asp"},
    {:name => "Loan",       :type => 'debt',    :removable => true,  :description => "Loan. Note that housing loans will be captured by the housing goal. If you have student debt please put it here.", :description_more_link => "http://www.investopedia.com/terms/u/unsecuredloan.asp"},
    {:name => "HSA",        :type => 'current', :removable => true,  :description => ""},
    {:name => "Investment", :type => 'invest',  :removable => true,  :description => ""},
    {:name => "Traditional IRA", :type => 'invest', :removable => true, :description => ""},
    {:name => "Roth IRA",   :type => 'invest',  :removable => true, :description => ""},
    {:name => "401K",       :type => 'invest',  :removable => true, :description => ""},
  ]
  
  INVESTMENT_TYPES = [
    "Money Market",
    "Bonds",
    "Stock",
    "International Stock",
    "Target Retirement"
  ]

  validates :balance, :numericality => { :if => lambda {|acct| acct.is_debt? }, :only_integer => true, :less_than_or_equal_to => 0, :message => "Debts should be expressed as negative amounts" }
  #validates :balance, :numericality => { , :only_integer => true, :less_than_or_equal_to => 0,  }

  def kind
    KINDS.detect { |a| a[:name] == self.name }
  end

  def description
    kind[:description]
  end

  def description_more_link
    kind[:description_more_link]
  end

  def can_remove?
    return false if new_record?

    kind[:removable]
  end
  
  def can_invest?
    new_record? || kind[:type] == 'invest'
  end
  
  def is_debt?
    kind[:type] == 'debt'
  end
  
  def safe_json
    {
      :id => self.id,
      :name => self.name,
      :balance => self.balance,
      :investment_type => self.investment_type,
      :interest_rate => self.interest_rate,
      :term => self.term,
      :limit => self.limit,
      :description => {
        :text => kind[:description],
        :more_link => kind[:description_more_link]
      }
    }
  end
  
end
