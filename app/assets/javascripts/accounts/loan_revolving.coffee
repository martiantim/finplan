class RevolvingLoan extends Loan
  constructor: (name, amount, rate, @limit) ->
    super(name, amount, rate, 2014, 10, false)
    @type = 'credit cards'

  pay: (balances) ->
    #add interest
    newInterest = @getBalance() * @rate
    minimumPayment = @getBalance() * -1.0 * (@rate + 0.02)
    @setBalance(@getBalance() + newInterest)

    #XXX mimum is always interest + 2%
    if minimumPayment > 0
      @deposit(minimumPayment)
      balances.spendCash(minimumPayment, 'Living', 'Credit Card Payment', {loan: true})

window.RevolvingLoan = RevolvingLoan