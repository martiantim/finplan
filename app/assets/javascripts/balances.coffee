class Balances
  constructor: (@startAccounts, @opts) ->      
    @accounts = {
      checking: new CheckingAccount(0), 
      emergency: new Account('emergency',0),
      savings: new Account('savings', 0),
      retirement: new Account('retirement', 0),
      '401k': new Account('401K', 0)
    }
    for acct in @startAccounts      
      name = acct.type.toLowerCase()
      if @accounts[name]
        @accounts[name].setBalance(acct.balance)
        @accounts[name].investmentType = acct.investmentType
      else
        console.log "Can't find account of type #{name}"
        
    @logs = {}    
    @snapshots = {}
    @year_incomes = {}
    @year_incomes_byuser = {}
    @year_spends = {}
    @year_deductions = {}
    @year_spends_notax = {}

  getAccount: (name) ->
    @accounts[name]

  _currentYear: ->
    @opts['year']
  
  logForYear: (year) ->
    @logs[year]
    
  snapshotForYear: (year) ->
    @snapshots[year]    

  curLog: ->
    yr = @_currentYear()
    @logs[yr] = new Log(yr) if !@logs[yr]
    @logs[yr]
  
  getOption: (name) ->
    @opts[name]
  
  getTotal: ->
    tot = 0
    for name, a of @accounts
      tot += a.balance
    tot
    
  getSavings: ->
    @accounts['savings'].balance
    
  getCash: ->
    @accounts['checking'].balance
    
  getRetirement: ->
    @accounts['retirement'].balance + @accounts['401k'].balance
    
  hasRetirement: (amount) ->
    @getRetirement() >= amount
    
  getCurrentYearIncome: ->
    @year_incomes[@_currentYear()] || 0

  getCurrentYearPersonIncome: (u) ->
    if @year_incomes_byuser[u.id]
      @year_incomes_byuser[u.id][@_currentYear()] || 0
    else
      0

  getCurrentYearDeductions: ->
    @year_deductions[@_currentYear()] || 0

  getAllIncomes: ->
    arr = []
    for k,v of @year_incomes
      arr.push v
    arr
  
  getTotalSavings: ->
    @getCash() + @getSavings()
  
  hasSavings: (amount) ->
    @getSavings() >= amount
  
  addRetirement: (amount, account, desc) ->
    if isNaN(amount)
      alert "Invalid retirement '#{amount}' for #{kind}"
    @accounts[account].deposit(amount)
    @curLog().log('Saving', desc, amount)
  
  addCash: (amount, user, kind, desc) ->
    if isNaN(amount)
      alert "Invalid earning '#{amount}' for #{kind}"
    @year_incomes[@_currentYear()] = 0 if !@year_incomes[@_currentYear()]
    @year_incomes[@_currentYear()] += amount
    if user
      @year_incomes_byuser[user.id] = {} if !@year_incomes_byuser[user.id]
      @year_incomes_byuser[user.id][@_currentYear()] = 0 if !@year_incomes_byuser[user.id][@_currentYear()]
      @year_incomes_byuser[user.id][@_currentYear()] += amount
    
    @accounts['checking'].deposit(amount)    
    @curLog().log(kind, desc, amount)    
    @recalc()
  
  spendCash: (amount, kind, description, opts = {}) ->
    if isNaN(amount)
      alert "Invalid spending '#{amount}' for #{kind}:#{description}"
    @year_spends[@_currentYear()] = 0 if !@year_spends[@_currentYear()]
    @year_spends[@_currentYear()] += amount if kind != 'Capital'   
    
    @year_spends_notax[@_currentYear()] = 0 if !@year_spends_notax[@_currentYear()]
    @year_spends_notax[@_currentYear()] += amount if kind != 'Capital' && kind != 'Taxes'

    if opts && opts['deductable']
      @year_deductions[@_currentYear()] = 0 if !@year_deductions[@_currentYear()]
      @year_deductions[@_currentYear()] += amount

    if @accounts['checking'].balance + @accounts['savings'].balance < amount      
      @takeOutLoan(amount, description)
    else    
      @accounts['checking'].spend(amount)
    
    @curLog().log(kind, description, -1 * amount)  
    @recalc()
  
  rebalance: ->
    @accounts['checking'].rebalance(@accounts['savings'])    
  
  currentYear: ->
    @opts['year']
  
  takeOutLoan: (amnt, whatfor, term = 10) ->
    name = "#{whatfor} #{@_currentYear()}"
    @accounts[name] = new Loan(amnt, 0.04213, @_currentYear(), term, whatfor == 'House Mortgage')
  
  earnFromInvestments: ->
    for name, acct of @accounts
      earnings = acct.calculateInvestmentReturns(@opts)
      if earnings > 0
        @curLog().log('Investment Income', "#{acct.type} Investment Return", earnings)
  
  addYear: ->              
    @curLog().log('Savings', 'Left Over', @year_incomes[@_currentYear()] - @year_spends[@_currentYear()])
    @snapshots[@_currentYear()] = new BalanceSnapshot(@_currentYear(), this)
    @opts['age']++
    @opts['year']++
  
  payLoans: ->
    that = this
    for name, a of @accounts
      if a.type == 'loan'        
        a.pay(that)
        
      
    
  recalc: ->
    
  highestTotal: ->
    high = 0
    for year, snap of @snapshots
      if snap.highestTotal() > high
        high = snap.highestTotal()
    high

  lowestTotal: ->
    low = 0
    for year, snap of @snapshots
      if snap.lowestTotal() < low
        low = snap.lowestTotal()
    low

  printState: ->
    console.log("Year "+@_currentYear())
    console.log("  Cash: "+@cash)
    console.log("  Savings: "+@savings)
    
window.Balances = Balances