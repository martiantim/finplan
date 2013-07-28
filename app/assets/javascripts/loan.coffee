class Loan extends Account
  constructor: (amount, @rate, @startYear, @termYears) ->
    console.log "new loan for #{@termYears}"
    @loanAmount = amount
    super('loan', -1 * amount)
    
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
    monthOfPayment = 1 + (balances._currentYear() - @startYear)*12
    #console.log("Year #{balances._currentYear()} Mortgage payment #{@_monthlyPayment()} principal #{@_principalPayment(monthOfPayment)}")
    if @balance < 0
      balances.spendCash(@_yearPayment(), 'Living', 'Loan Payment')
      for month in [monthOfPayment..(monthOfPayment)+11]
        @deposit(@_principalPayment(month))
    
window.Loan = Loan