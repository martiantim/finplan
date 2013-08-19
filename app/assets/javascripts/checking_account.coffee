class CheckingAccount extends Account
  constructor: (balance) ->
    @maxToHold = 3000
    super('checking', balance)
    
  rebalance: (savings) ->
    if @balance > @maxToHold
      savings.transfer(this, @balance - @maxToHold)      
    if @balance < @maxToHold
      @transfer(savings, Math.min(@maxToHold-@balance, savings.balance))
    
window.CheckingAccount = CheckingAccount