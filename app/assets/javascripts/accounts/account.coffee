class Account
  constructor: (@type, @balance, @investmentType) ->
    @investmentType = 'Money Market' if !@investmentType

  setBalance: (bal) ->
    @balance = bal
  
  deposit: (amnt) ->
    @balance += amnt
  
  spend: (amnt) ->
    if amnt > @balance
      moreNeeded = amnt - @balance
      @balance = 0
      moreNeeded
    else
      @balance -= amnt
      0
  
  transfer: (fromAcct, amnt) ->
    if fromAcct.balance < amnt
      alert "Error trying to transfer #{amnt} from #{fromAcct.type}"
    fromAcct.spend(amnt)
    @deposit(amnt)    
    
  transferUpTo: (fromAcct, amnt) ->
    if fromAcct.balance < amnt
      amnt = fromAcct.balance
    fromAcct.spend(amnt)
    @deposit(amnt)        
    
  calculateInvestmentReturns: (markets) ->
    rate = markets.returnOfType(@investmentType)

    @earnings = @balance * rate
    @balance += @earnings
    @earnings

  is_retirement: ->
    false

  withdraw: (amount) ->
    @balance -= amount

  @fromJSON: (json) ->
    if json.interest_rate
      new Loan(json.name, json.balance, json.interest_rate/100.0, finData['current_year'], json.term || 30, false)
    else
      new Account(json.name, json.balance, json.investment_type || 'None')


window.Account = Account