class HomeLoan extends Loan
  constructor: (name, amount, @houseCost, rate, startYear, termYears, deductable) ->
    super(name, amount, rate, startYear, termYears, deductable)

  pay: (balances) ->
    super(balances)

    #pay PMI if owe it
    # take the purchase price less the down payment, then add 2.25 % and times that number by .55% and divide it by 12.  that is your monthly pmi
    #90.01 - 95% LTV...   MI = .67% of the loan amount
    #85.01-90% LTV...   MI = .49%
    #85% and under...   MI = .32%
    if (@getBalance() * -1.0)/@houseCost > 0.8
      ltv = @loanAmount / @houseCost
      if ltv >= 0.9
        pmiRate = 0.0067
      else if ltv >= 0.85
        pmiRate = 0.0049
      else
        pmiRate = 0.0032

      pmi = @loanAmount * 1.025 * pmiRate
      balances.spendCash(pmi, 'Living', 'Home Loan PMI', {loan: true})

window.HomeLoan = HomeLoan