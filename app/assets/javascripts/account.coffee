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
      @balance = @balance * 1.06
    else if @investmentType == 'Target Retirement'
      mult = 1.0
      if opts['age'] < 50
        mult = 1.08
      else if opts['age'] < 60
        mult = 1.06
      else if opts['age'] < 67
        mult = 1.04      
      else
        mult = 1.02
      @balance = @balance * mult
    
  @fromJSON: (json) ->
    new Account(json.name, json.balance, json.investment_type)    
  
window.Account = Account