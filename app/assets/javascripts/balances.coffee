class Balances
  constructor: (@opts) ->
    @cash = 0
    @savings = 0
    @investments = 0
        
    @log = {}
    @log[@_currentYear()] = []
    @year_incomes = {}
    @highest_total = 0
  
  _currentYear: ->
    @opts['year']
  
  yearLog: (year) ->
    @log[year]
  
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
    
  addCash: (amount, kind) ->
    if isNaN(amount)
      alert "Invalid earning '#{amount}' for #{kind}"
    @year_incomes[@_currentYear()] = 0 if !@year_incomes[@_currentYear()]
    @year_incomes[@_currentYear()] += amount
    
    console.log("amount = " + amount)
    
    @cash += amount
    @log[@_currentYear()].push "$#{amount} #{kind}"
    @recalc()
  
  spendCash: (amount, kind, description) ->    
    if isNaN(amount)
      alert "Invalid spending '#{amount}' for #{kind}:#{description}"
    @cash -= amount
    @log[@_currentYear()].push "$#{amount} #{kind}: #{description}"
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
    @opts['age']++
    @opts['year']++
    @log[@_currentYear()] = []
  
  recalc: ->
    @highest_total = @getTotal() if @getTotal() > @highest_total
    
  highestTotal: ->
    @highest_total
  
  printState: ->
    console.log("Year "+@_currentYear())
    console.log("  Cash: "+@cash)
    console.log("  Savings: "+@savings)
    
window.Balances = Balances