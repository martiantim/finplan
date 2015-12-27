class RetirementAccount extends Account
  constructor: (name, @kind, amount) ->
    super(name, amount)


  is_retirement: ->
    true

  withdrawToCheckingUpTo: (amnt, balances, person) ->
    moreNeeded = @spend(amnt)
    if @kind == 'pretax'
      balances.addCash(amnt - moreNeeded, person, 'Income', "#{name} Withdraw", {skip_fica: true})
    else if @kind == 'posttax'
      balances.addCash(amnt - moreNeeded, person, 'Income', "#{name} Withdraw", {skip_fica: true, skip_income: true})
    else
      alert("Unknown kind #{@kind}")
    moreNeeded




window.RetirementAccount = RetirementAccount