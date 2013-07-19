class CheckingAccount extends Account
  constructor: (balance) ->
    super('checking', balance)
    
  rebalance: (savings) ->
    if @balance > 5000
      savings.transfer(this, @balance - 5000)      
    if @balance < 5000
      @transfer(savings, Math.min(5000-@balance, savings.balance))
    
window.CheckingAccount = CheckingAccount