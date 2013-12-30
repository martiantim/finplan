class RetirementAccount extends Account
  constructor: (name, @kind, amount) ->
    super(name, amount)


  is_retirement: ->
    true


window.RetirementAccount = RetirementAccount