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
      @stdrnd(avg, stdev)
    else if iType == 'Bonds'
      avg = 0.053
      stdev = 0.057
      @stdrnd(avg, stdev)
    else if iType == 'Stock'
      avg = 0.104
      stdev = 0.202
      @stdrnd(avg, stdev)
    else if iType == 'Target Retirement'
      if opts['age'] < 50
        stocks = 0.9
        bonds = 0.1
      else if opts['age'] < 60
        stocks = 0.8
        bonds = 0.2
      else if opts['age'] < 67
        stocks = 0.4
        bonds = 0.6
      else
        stocks = 0.1
        bonds = 0.9

      stocks * @stdrnd(0.104, 0.202) + bonds * @stdrnd(0.053, 0.057)
    else if iType == 'None'
      0.0
    else
      alert("Unknown innvestment type: #{iType}")

  rnd_snd: ->
    (Math.random()*2-1)+(Math.random()*2-1)+(Math.random()*2-1)

  stdrnd: (mean, stdev) ->
    @rnd_snd()*stdev+mean


  @fromJSON: (json) ->
    if json.interest_rate
      new Loan(json.balance, json.interest_rate/100.0, 2013, 30, false)
    else
      new Account(json.name, json.balance, json.investment_type || 'None')


window.Account = Account