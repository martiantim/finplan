class Balances
  constructor: (@opts) ->
    @cash = 0
    @savings = 0
    @investments = 0
        
    @logs = {}    
    @year_incomes = {}
    @year_spends = {}
    @highest_total = 0

  _currentYear: ->
    @opts['year']
  
  logForYear: (year) ->
    @logs[year]

  curLog: ->
    yr = @_currentYear()
    @logs[yr] = new Log(yr) if !@logs[yr]
    @logs[yr]
  
  getOption: (name) ->
    @opts[name]
  
  getTotal: ->
    @cash + @savings + @investments
    
  getSavings: ->
    @savings
    
  getCash: ->
    @cash
    
  getCurrentYearIncome: ->
    @year_incomes[@_currentYear()] || 0

  getAllIncomes: ->
    arr = []
    for k,v of @year_incomes
      arr.push v
    arr
    
  addSavings: (amount) ->
    @savings = @savings + amount
    @recalc()
    
  addCash: (amount, kind, desc) ->
    if isNaN(amount)
      alert "Invalid earning '#{amount}' for #{kind}"
    @year_incomes[@_currentYear()] = 0 if !@year_incomes[@_currentYear()]
    @year_incomes[@_currentYear()] += amount
    
    @cash += amount
    @curLog().log(kind, desc, amount)    
    @recalc()
  
  spendCash: (amount, kind, description) ->    
    if isNaN(amount)
      alert "Invalid spending '#{amount}' for #{kind}:#{description}"
    @year_spends[@_currentYear()] = 0 if !@year_spends[@_currentYear()]
    @year_spends[@_currentYear()] += amount      
      
    @cash -= amount
    @curLog().log(kind, description, -1 * amount)  
    @recalc()
  
  rebalance: ->
    if @cash > 5000
      @savings += (@cash - 5000)
      @cash = 5000
    if @cash < 0
      if @savings > 5000
        @cash = 5000
        @savings -= 5000
      else
        @cash = @savings      
  
  currentYear: ->
    @opts['year']
  
  addYear: ->
    @curLog().log('Savings', 'Left Over', @year_incomes[@_currentYear()] - @year_spends[@_currentYear()])
    @opts['age']++
    @opts['year']++    
    
  recalc: ->
    @highest_total = @getTotal() if @getTotal() > @highest_total
    
  highestTotal: ->
    @highest_total
  
  printState: ->
    console.log("Year "+@_currentYear())
    console.log("  Cash: "+@cash)
    console.log("  Savings: "+@savings)
    
window.Balances = Balances