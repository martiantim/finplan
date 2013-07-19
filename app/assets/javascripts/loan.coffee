class Loan extends Account
  constructor: (amount, @rate, @termYears) ->
    @loanAmount = amount
    super('loan', -1 * amount)
    
  _yearPayment: ->
    r = @rate / 12
    N = @termYears * 12
    P = @loanAmount
    
    monthlyPayment = (P*r*(Math.pow(1+r,N)))/(Math.pow(1+r, N) - 1)
    monthlyPayment*12
  
  pay: (balances) ->
    if @balance < 0
      balances.spendCash(@_yearPayment(), 'Living', 'Loan Payment')
      @deposit(@loanAmount/@termYears)
    
window.Loan = Loan