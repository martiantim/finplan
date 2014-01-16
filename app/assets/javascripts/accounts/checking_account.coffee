class CheckingAccount extends Account
  constructor: (balance) ->
    @maxToHold = 3000
    super('checking', balance, 'None')
    
  rebalance: (otherAccount, log) ->
    if @balance > @maxToHold
      amnt = @balance - @maxToHold
      otherAccount.transfer(this, amnt)
      log.log("account:#{otherAccount.type.toLowerCase()}", "Savings", amnt)
    if @balance < @maxToHold
      amnt = Math.min(@maxToHold-@balance, otherAccount.balance)
      @transfer(otherAccount, amnt)
      log.log("account:#{otherAccount.type.toLowerCase()}", "Transfer to Checking", -1 * amnt)

    
window.CheckingAccount = CheckingAccount