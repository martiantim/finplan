class CheckingAccount extends Account
  constructor: (balance) ->
    @maxToHold = 3000
    super('checking', balance, 'None')
    
  rebalance: (savings, log) ->
    if @balance > @maxToHold
      amnt = @balance - @maxToHold
      savings.transfer(this, amnt)
      log.log("account:savings", "Savings", amnt)
    if @balance < @maxToHold
      amnt = Math.min(@maxToHold-@balance, savings.balance)
      @transfer(savings, amnt)
      log.log("account:savings", "Transfer to Checking", -1 * amnt)

    
window.CheckingAccount = CheckingAccount