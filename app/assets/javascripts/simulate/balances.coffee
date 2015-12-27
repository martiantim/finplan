class Balances
  constructor: (@simcontext, @startAccounts, @opts) ->
    @accounts = {
      checking: new CheckingAccount(0), 
      emergency: new Account('emergency',0),
      savings: new Account('savings', 0),
      retirement: new Account('retirement', 0),
      'credit cards': new RevolvingLoan('credit cards', 0, 0),
      '401k': new RetirementAccount('401K', 'pretax', 0),
      'traditional ira': new RetirementAccount('Traditional IRA', 'pretax', 0),
      'roth ira': new RetirementAccount('ROTH IRA', 'posttax', 0)
    }
    for acct in @startAccounts
      name = acct.type.toLowerCase()
      if @accounts[name]
        @accounts[name].setBalance(acct.balance)
        @accounts[name].investmentType = acct.investmentType
        if (acct instanceof RevolvingLoan)
          @accounts[name].limit = acct.limit
          @accounts[name].rate = acct.rate
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
    
  getSavings: (includeCredit = true) ->
    total = @accounts['savings'].balance + @accounts['checking'].balance + @accounts['emergency'].balance
    total += @accounts['credit cards'].balance if includeCredit
    total

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
  
  hasSavings: (amount, includeCredit = true) ->
    @getSavings(includeCredit) >= amount
  
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
      alert "Invalid earning '#{amount}' for #{kind}:#{desc}"

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

    if !@hasAmountToSpend(amount, opts['disallowCredit'])
      if opts['loan']
        throw new BankruptcyException("Unable to pay #{FUtils.formatMoney(amount)} for #{description} in #{@simcontext.simYear}")
      else
        @takeOutLoan(amount, description)
    else
      left = @_cascadingSpend(amount, opts['disallowCredit'])
      throw new BankruptcyException("Unable to pay #{amount} for #{description} in #{@simcontext.simYear} during cascading spend") if left > 0
    
    @curLog().log(kind, description, -1 * amount)  
    @recalc()

  _withdrawInRetirement: (amount) ->
    age = @simcontext.oldestAdultAge()
    person = @simcontext.family.oldestMember(@simcontext.simYear)
    if amount > 0 && age >= 55
      left = @accounts['401k'].withdrawToCheckingUpTo(amount, this, person)
    if left > 0 && age >= 60
      left = @accounts['roth ira'].withdrawToCheckingUpTo(left, this, person)
    if left > 0 && age >= 60
      left = @accounts['traditional ira'].withdrawToCheckingUpTo(left, this, person)


  _cascadingSpend: (amount, disallowCredit) ->
    left = @accounts['checking'].spend(amount)
    if left > 0
      left = @accounts['savings'].spend(left)
      if left > 0
        left = @accounts['emergency'].spend(left)
        if left > 0 && !disallowCredit
          left = @accounts['credit cards'].spend(left)
        if left > 0
          console.log("NEED MORE #{left}")
          @_withdrawInRetirement(left)
          left = @accounts['checking'].spend(left)
    left


  hasAmountToSpend: (amnt, disallowCredit) ->
    balance = @accounts['checking'].balance + @accounts['savings'].balance + @accounts['emergency'].balance
    if !disallowCredit
      balance += @accounts['credit cards'].amountAvailable()

    age = @simcontext.oldestAdultAge()
    if age >= 55 #TODO
      balance += @accounts['401k'].balance
    if age >= 60
      balance += @accounts['traditional ira'].balance + @accounts['roth ira'].balance
    balance >= amnt

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

  takeOutHomeLoan: (amnt, whatfor, term = 10, houseCost, context) ->
    startYear = context.simYear
    rate = context.markets.rate('Mortgage')
    name = "#{whatfor} #{startYear}"

    @accounts[name] = new HomeLoan(name, amnt, houseCost, rate, startYear, @_currentYear(), term, true)
    @accounts['House'] = new House(houseCost)
    #pay 1st year
    @payLoan(@accounts[name])

  takeOutLoan: (amnt, whatfor, term = 10) ->
    name = "#{whatfor} #{@_currentYear()}"
    @accounts[name] = new Loan(name, amnt, 0.04213, @_currentYear(), @_currentYear(), term, false)
    #pay 1st year
    @payLoan(@accounts[name])
  
  earnFromInvestments: (markets) ->
    for name, acct of @accounts
      earnings = acct.calculateInvestmentReturns(markets)
      if earnings && earnings != 0
        @curLog().log("account:#{name}", "Investment Return", earnings)

  moneyLeftOver: ->
    income = @year_incomes[@_currentYear()] || 0
    income - @year_spends[@_currentYear()]

  addYear: ->              
    @curLog().log('Savings', 'Left Over', @moneyLeftOver())
    @snapshots[@_currentYear()] = new BalanceSnapshot(@_currentYear(), this)
    @opts['year']++
  
  payLoans: ->
    for name, a of @accounts
      if a.type == 'loan'
        @payLoan(a)
      else if (a instanceof RevolvingLoan)
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