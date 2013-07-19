class Balances
  constructor: (@opts) ->
    @accounts = {
      checking: new CheckingAccount(10000), 
      savings: new Account('savings', 0)
    }
        
    @logs = {}    
    @snapshots = {}
    @year_incomes = {}
    @year_spends = {}

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
      console.log a.balance
      tot += a.balance
    tot
    
  getSavings: ->
    @accounts['savings'].balance
    
  getCash: ->
    @accounts['checking'].balance
    
  getCurrentYearIncome: ->
    @year_incomes[@_currentYear()] || 0

  getAllIncomes: ->
    arr = []
    for k,v of @year_incomes
      arr.push v
    arr
    
  hasSavings: (amount) ->
    (@getCash() + @getSavings()) >= amount
  
  addCash: (amount, kind, desc) ->
    if isNaN(amount)
      alert "Invalid earning '#{amount}' for #{kind}"
    @year_incomes[@_currentYear()] = 0 if !@year_incomes[@_currentYear()]
    @year_incomes[@_currentYear()] += amount
    
    @accounts['checking'].deposit(amount)    
    @curLog().log(kind, desc, amount)    
    @recalc()
  
  spendCash: (amount, kind, description) ->    
    if isNaN(amount)
      alert "Invalid spending '#{amount}' for #{kind}:#{description}"
    @year_spends[@_currentYear()] = 0 if !@year_spends[@_currentYear()]
    @year_spends[@_currentYear()] += amount if kind != 'Capital'   
    
    if amount == 20000
      console.log "car i think #{description}"
      
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
  
  takeOutLoan: (amnt, whatfor) ->
    name = "#{whatfor} #{@_currentYear()}"
    @accounts[name] = new Loan(amnt, 0.06, 10)
  
  addYear: ->
    @payLoans()
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