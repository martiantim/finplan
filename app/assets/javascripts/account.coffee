class Account
  constructor: (@type, @balance, @investmentType) ->
  
  setBalance: (bal) ->
    @balance = bal
  
  deposit: (amnt) ->
    @balance += amnt
  
  spend: (amnt) ->
    @balance -= amnt
  
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
    
  calculateInvestmentReturns: (opts) ->
    if @investmentType == 'Stock'
      ret = 0.06
    else if @investmentType == 'Target Retirement'
      ret = 0.0
      if opts['age'] < 50
        ret = 0.08
      else if opts['age'] < 60
        ret = 0.06
      else if opts['age'] < 67
        ret = 0.04      
      else
        ret = 0.02
        
      @earnings = @balance * ret
      @balance += @earnings
      @earnings
    
  @fromJSON: (json) ->
    new Account(json.name, json.balance, json.investment_type)    
  
window.Account = Account