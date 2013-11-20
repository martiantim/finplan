class Account
  constructor: (@type, @balance, @investmentType) ->
    @investmentType = 'Money Market' if !@investmentType
  
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
    rate = @returnRate(@investmentType, opts)
        
    @earnings = @balance * rate
    @balance += @earnings
    @earnings

  #rates from http://www.bogleheads.org/wiki/Historical_and_expected_returns
  returnRate: (iType, opts) ->
    if iType == 'Money Market'
      avg = 0.037
      stdev = 0.031
    else if iType == 'Bonds'
      avg = 0.053
      stdev = 0.057
    else if iType == 'Stock'
      avg = 0.104
      stdev = 0.202
    else if iType == 'Target Retirement'
      avg = 0.05
      stdev = 0.10
      ret = 0.0
      if opts['age'] < 50
        ret = 0.08
      else if opts['age'] < 60
        ret = 0.06
      else if opts['age'] < 67
        ret = 0.04
      else
        ret = 0.02
    else
      alert("Unknown innvestment type: #{iType}")

    @stdrnd(avg, stdev)


  rnd_snd: ->
    (Math.random()*2-1)+(Math.random()*2-1)+(Math.random()*2-1)

  stdrnd: (mean, stdev) ->
    @rnd_snd()*stdev+mean


  @fromJSON: (json) ->
    new Account(json.name, json.balance, json.investment_type)    


window.Account = Account