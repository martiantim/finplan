class Loan extends Account
  constructor: (@name, amount, @rate, @startYear, @termYears, @deductable) ->
    @loanAmount = amount
    super('loan', -1 * amount, 'None')
    
  _monthlyPayment: ->
    r = @rate / 12
    N = @termYears * 12
    P = @loanAmount
    
    (P*r*(Math.pow(1+r,N)))/(Math.pow(1+r, N) - 1)
    
  _yearPayment: ->    
    @_monthlyPayment()*12
  
  _principalPayment: (month) ->
    A = @_monthlyPayment()
    i = @rate / 12
    n = @termYears * 12
    P0 = @loanAmount
    
    A * Math.pow(1+i, month-1) - P0 * i * Math.pow(1+i, month-1)
  
  pay: (balances) ->
    monthOfPayment = 1 + (balances._currentYear() - @startYear - 1)*12
    if @balance < 0
      console.log(this)
      yearCost = @_yearPayment()
      interest = yearCost
      yearCost = -1 * @balance if yearCost + @balance > 0
      for month in [monthOfPayment..(monthOfPayment)+11]
        if @balance < 0
          payment = @_principalPayment(month)
          payment = -1 * @balance if payment + @balance > 0
          @deposit(payment)
          interest -= payment
      balances.spendCash(interest, 'Living', 'Loan Payment Interest', {deductable: @deductable})
      balances.spendCash(yearCost - interest, 'Living', 'Loan Payment Principal')
      return yearCost

  calculateInvestmentReturns: (opts) ->
    #do nothing

  duplicate: ->
    new Loan(@name, @loanAmount, @rate, @startYear, @termYears, @deductable)

window.Loan = Loan