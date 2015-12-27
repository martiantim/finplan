class RevolvingLoan extends Loan
  constructor: (name, amount, rate, @limit) ->
    super(name, -1 * amount, rate, 2014, 10, false)
    @type = 'credit cards'

  pay: (balances) ->
    #add interest
    newInterest = @getBalance() * @rate
    minimumPayment = @getBalance() * -1.0 * (@rate + 0.02)
    @setBalance(@getBalance() + newInterest)
    balances.curLog().log("account:#{@type}", "Interest", newInterest)

    #XXX mimum is always interest + 2%
    if minimumPayment > 0
      @deposit(minimumPayment)
      balances.spendCash(minimumPayment, 'Living', 'Credit Card Payment', {loan: true})

    minimumPayment

  spend: (amnt) ->
    avail = @amountAvailable()
    if avail < amnt
      @balance -= avail
      amnt - avail
    else
      @balance -= amnt
      0 #nothing left to pay

  amountAvailable: ->
    return 0 if !@limit
    @limit + @getBalance()

window.RevolvingLoan = RevolvingLoan