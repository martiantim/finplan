class Balances
  constructor: (@simcontext, @startAccounts, @opts) ->
    @accounts = {
      checking: new CheckingAccount(0), 
      emergency: new Account('emergency',0),
      savings: new Account('savings', 0),
      retirement: new Account('retirement', 0),
      '401k': new RetirementAccount('401K', 'pretax', 0),
      'traditional ira': new RetirementAccount('Traditional IRA', 'pretax', 0),
      'roth ira': new RetirementAccount('ROTH IRA', 'posttax', 0)
    }
    for acct in @startAccounts      
      name = acct.type.toLowerCase()
      if @accounts[name]
        @accounts[name].setBalance(acct.balance)
        @accounts[name].investmentType = acct.investmentType
      else if name == 'loan'
        @accounts['loan'] = acct.duplicate()
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
    @accounts['savings'].balance + @accounts['checking'].balance + @accounts['emergency'].balance

  getLoans: ->
    total = 0
    for name, a of @accounts
      if a.type == 'loan'
        total += a.balance
    total

  getRetirement: ->
    total = 0
    for name, acct of @accounts
      if acct.is_retirement()
        total += acct.balance
    total

  getNet_Worth: ->
    total = 0
    for name, acct of @accounts
      total += acct.balance
    total
    
  hasRetirement: (amount) ->
    @getRetirement() >= amount
    
  getCurrentYearIncome: ->
    @year_incomes[@_currentYear()] || 0

  getCurrentYearPersonIncome: (u) ->
    if @year_incomes_byuser[u.id] && @year_incomes_byuser[u.id][@_currentYear()]
      @year_incomes_byuser[u.id][@_currentYear()]['income']
    else
      0

  getCurrentYearPersonFICAIncome: (u) ->
    if @year_incomes_byuser[u.id] && @year_incomes_byuser[u.id][@_currentYear()]
      @year_incomes_byuser[u.id][@_currentYear()]['fica']
    else
      0

  getCurrentYearDeductions: ->
    @year_deductions[@_currentYear()] || 0

  getAllIncomes: ->
    arr = []
    for k,v of @year_incomes
      arr.push v
    arr

  getAllIncomesByUser: (user) ->
    arr = []
    for k,v of @year_incomes_byuser[user.id]
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
    @curLog().log('Savings', desc, amount)
    @curLog().log("account:#{account}", "Savings", amount)

  _yearIncome: (amount, user, options) ->
    @year_incomes[@_currentYear()] = 0 if !@year_incomes[@_currentYear()]
    @year_incomes[@_currentYear()] += amount if !options['skip_income']
    if user
      @year_incomes_byuser[user.id] = {} if !@year_incomes_byuser[user.id]
      @year_incomes_byuser[user.id][@_currentYear()] = {income: 0, fica: 0} if !@year_incomes_byuser[user.id][@_currentYear()]
      if !options['skip_income']
        @year_incomes_byuser[user.id][@_currentYear()]['income'] += amount
      if !options['skip_fica']
        @year_incomes_byuser[user.id][@_currentYear()]['fica'] += amount

  addCash: (amount, user, kind, desc, options = {}) ->
    if isNaN(amount)
      alert "Invalid earning '#{amount}' for #{kind}"

    @_yearIncome(amount, user, options)
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

    if !@hasAmountToSpend(amount)
      if opts['loan']
        console.log("BANKRUPT!")
      else
        @takeOutLoan(amount, description)
    else    
      @accounts['checking'].spend(amount)
    
    @curLog().log(kind, description, -1 * amount)  
    @recalc()

  hasAmountToSpend: (amnt) ->
    balance = @accounts['checking'].balance + @accounts['savings'].balance

    age = @simcontext.oldestAdultAge()
    if age >= 55 #TODO
      balance += @accounts['401k'].balance
    if age >= 60
      balance += @accounts['traditional ira'].balance + @accounts['roth ira'].balance
    balance > amnt

  rebalance: ->
    @accounts['checking'].rebalance(@accounts['savings'], @curLog())
    age = @simcontext.oldestAdultAge()
    if age >= 55 #TODO
      @accounts['checking'].rebalance(@accounts['401k'], @curLog())
    if age >= 60
      @accounts['checking'].rebalance(@accounts['traditional ira'], @curLog())
      @accounts['checking'].rebalance(@accounts['roth ira'], @curLog())
  
  currentYear: ->
    @opts['year']
  
  takeOutLoan: (amnt, whatfor, term = 10) ->
    name = "#{whatfor} #{@_currentYear()}"
    @accounts[name] = new Loan(name, amnt, 0.04213, @_currentYear(), term, whatfor == 'House Mortgage')
    #pay 1st year
    @payLoan(@accounts[name])
  
  earnFromInvestments: (markets) ->
    for name, acct of @accounts
      earnings = acct.calculateInvestmentReturns(markets)
      if earnings && earnings != 0
        @curLog().log("account:#{name}", "Investment Return", earnings)
  
  addYear: ->              
    @curLog().log('Savings', 'Left Over', @year_incomes[@_currentYear()] - @year_spends[@_currentYear()])
    @snapshots[@_currentYear()] = new BalanceSnapshot(@_currentYear(), this)
    @opts['year']++
  
  payLoans: ->
    for name, a of @accounts
      if a.type == 'loan'
        @payLoan(a)

  payLoan: (acct) ->
    amount = acct.pay(this)
    if amount && amount != 0
      @curLog().log("account:#{acct.name}", "Loan Payments", amount)

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